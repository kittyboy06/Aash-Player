import 'dart:async';
import 'package:audio_service/audio_service.dart' as audio_service;
import '../../../library/domain/entities/song.dart';
import '../../domain/entities/playback_state.dart';
import '../../domain/failures/playback_failure.dart';
import 'audio_handler.dart';
import 'playback_platform_service.dart';

class WindowsPlaybackService implements PlaybackPlatformService {
  late final AashAudioHandler _handler;
  final _stateController = StreamController<PlaybackState>.broadcast();
  final _positionController = StreamController<Duration>.broadcast();
  final _durationController = StreamController<Duration>.broadcast();
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  Song? _currentSong;
  Duration _currentDuration = Duration.zero;

  @override
  Future<void> initialize() async {
    _handler = await audio_service.AudioService.init<AashAudioHandler>(
      builder: () => AashAudioHandler(),
      config: const audio_service.AudioServiceConfig(
        androidNotificationChannelId: 'com.kittyboy06.aash_player.channel.audio',
        androidNotificationChannelName: 'Aash Player Playback',
        androidNotificationOngoing: true,
      ),
    );

    // Sync streams
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
  }

  @override
  Future<void> play() => _handler.play();

  @override
  Future<void> pause() => _handler.pause();

  @override
  Future<void> stop() async {
    _currentSong = null;
    await _handler.stop();
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
