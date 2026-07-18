import 'package:audio_service/audio_service.dart';
import 'package:media_kit/media_kit.dart';

class AashAudioHandler extends BaseAudioHandler with QueueHandler {
  AashAudioHandler() {
    _initPlayer();
  }

  late final Player _player;

  void _initPlayer() {
    _player = Player();

    // 1. Map completing event
    _player.stream.completed.listen((completed) {
      if (completed) {
        playbackState.add(playbackState.value.copyWith(
          processingState: AudioProcessingState.completed,
          playing: false,
        ));
      }
    });

    // 2. Map playing event
    _player.stream.playing.listen((playing) {
      playbackState.add(playbackState.value.copyWith(
        playing: playing,
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
      ));
    });

    // 3. Map position event
    _player.stream.position.listen((position) {
      playbackState.add(playbackState.value.copyWith(
        updatePosition: position,
      ));
    });

    // 4. Map duration event
    _player.stream.duration.listen((duration) {
      if (mediaItem.value != null) {
        mediaItem.add(mediaItem.value!.copyWith(duration: duration));
      }
    });
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.idle,
      playing: false,
    ));
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume * 100.0); // media_kit volume range is 0.0 to 100.0
  }

  Future<void> openUri(String uri, MediaItem item) async {
    mediaItem.add(item);
    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.loading,
      updatePosition: Duration.zero,
    ));

    try {
      await _player.open(Media(uri));
      playbackState.add(playbackState.value.copyWith(
        processingState: AudioProcessingState.ready,
      ));
    } catch (e) {
      playbackState.add(playbackState.value.copyWith(
        processingState: AudioProcessingState.error,
      ));
      rethrow;
    }
  }

  Future<void> cleanUp() async {
    await _player.dispose();
  }
}
