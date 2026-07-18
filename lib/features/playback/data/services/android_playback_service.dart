import 'dart:async';
import 'package:audio_service/audio_service.dart' as audio_service;
import 'package:audio_session/audio_session.dart';
import '../../../library/domain/entities/song.dart';
import '../../domain/entities/playback_state.dart';
import '../../domain/failures/playback_failure.dart';
import 'audio_handler.dart';
import 'playback_platform_service.dart';

class AndroidPlaybackService implements PlaybackPlatformService {
  late final AashAudioHandler _handler;
  final _stateController = StreamController<PlaybackState>.broadcast();
  final _positionController = StreamController<Duration>.broadcast();
  final _durationController = StreamController<Duration>.broadcast();
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  Song? _currentSong;
  Duration _currentDuration = Duration.zero;
  AudioSession? _audioSession;

  @override
  Future<void> initialize() async {
    // 1. Initialize Audio Handler
    _handler = await audio_service.AudioService.init<AashAudioHandler>(
      builder: () => AashAudioHandler(),
      config: const audio_service.AudioServiceConfig(
        androidNotificationChannelId: 'com.kittyboy06.aash_player.channel.audio',
        androidNotificationChannelName: 'Aash Player Playback',
        androidNotificationOngoing: true,
        androidShowNotificationBadge: true,
      ),
    );

    // 2. Configure Audio Session for Android Focus Management
    _audioSession = await AudioSession.instance;
    await _audioSession!.configure(const AudioSessionConfiguration.music());

    // Auto pause when headphones are unplugged
    _subscriptions.add(_audioSession!.becomingNoisyEventStream.listen((_) {
      pause();
    }));

    // Handle audio focus interruptions (calls, nav alerts, etc.)
    _subscriptions.add(_audioSession!.interruptionEventStream.listen((event) {
      if (event.begin) {
        switch (event.type) {
          case AudioInterruptionType.duck:
            // Lower volume
            _handler.setVolume(0.2);
            break;
          case AudioInterruptionType.pause:
          case AudioInterruptionType.unknown:
            pause();
            break;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.duck:
            // Restore volume
            _handler.setVolume(1.0);
            break;
          case AudioInterruptionType.pause:
            // Resume if it was playing
            play();
            break;
          case AudioInterruptionType.unknown:
            break;
        }
      }
    }));

    // 3. Sync streams
    _subscriptions.add(_handler.playbackState.listen((state) {
      final song = _currentSong;
      if (song != null) {
        _stateController.add(_mapState(state, song));
        _positionController.add(state.updatePosition);
      } else {
        _stateController.add(const PlaybackStateIdle());
      }
    }));

    _subscriptions.add(_handler.mediaItem.listen((item) {
      if (item != null && item.duration != null) {
        _currentDuration = item.duration!;
        _durationController.add(item.duration!);
      }
    }));
  }

  PlaybackState _mapState(audio_service.PlaybackState state, Song song) {
    final playing = state.playing;
    final processingState = state.processingState;

    return switch (processingState) {
      audio_service.AudioProcessingState.idle => const PlaybackStateStopped(),
      audio_service.AudioProcessingState.loading => PlaybackStateLoading(song),
      audio_service.AudioProcessingState.buffering => PlaybackStateBuffering(song, state.updatePosition),
      audio_service.AudioProcessingState.ready => playing
          ? PlaybackStatePlaying(
              song: song,
              position: state.updatePosition,
              duration: _currentDuration,
            )
          : PlaybackStatePaused(
              song: song,
              position: state.updatePosition,
              duration: _currentDuration,
            ),
      audio_service.AudioProcessingState.completed => PlaybackStateCompleted(song),
      audio_service.AudioProcessingState.error => PlaybackStateError(
          song: song,
          failure: PlaybackFailure.decodeFailure,
          message: 'Playback engine error',
        ),
    };
  }

  @override
  Future<void> open(Song song) async {
    // Request audio focus before starting playback
    if (await _audioSession?.setActive(true) ?? false) {
      _currentSong = song;
      final mediaItem = audio_service.MediaItem(
        id: song.filePath,
        album: song.albumId ?? 'Unknown Album',
        title: song.title,
        artist: song.artistId ?? 'Unknown Artist',
        duration: song.duration,
        artUri: song.artworkPath != null ? Uri.file(song.artworkPath!) : null,
      );

      await _handler.openUri(song.filePath, mediaItem);
    } else {
      throw Exception('Failed to acquire Android Audio Focus');
    }
  }

  @override
  Future<void> play() async {
    if (await _audioSession?.setActive(true) ?? false) {
      await _handler.play();
    }
  }

  @override
  Future<void> pause() => _handler.pause();

  @override
  Future<void> stop() async {
    _currentSong = null;
    await _handler.stop();
    await _audioSession?.setActive(false);
  }

  @override
  Future<void> seek(Duration position) => _handler.seek(position);

  @override
  Future<void> setVolume(double volume) => _handler.setVolume(volume);

  @override
  Future<void> dispose() async {
    _currentSong = null;
    for (final sub in _subscriptions) {
      await sub.cancel();
    }
    await _handler.cleanUp();
    await _audioSession?.setActive(false);
    await _stateController.close();
    await _positionController.close();
    await _durationController.close();
  }

  @override
  Stream<Duration> get positionStream => _positionController.stream;

  @override
  Stream<Duration> get durationStream => _durationController.stream;

  @override
  Stream<PlaybackState> get stateStream => _stateController.stream;
}
