import '../../../library/domain/entities/song.dart';
import '../failures/playback_failure.dart';

sealed class PlaybackState {
  const PlaybackState();
}

class PlaybackStateIdle extends PlaybackState {
  const PlaybackStateIdle();

  @override
  String toString() => 'PlaybackStateIdle';
}

class PlaybackStatePreparing extends PlaybackState {
  const PlaybackStatePreparing(this.song);
  final Song song;

  @override
  String toString() => 'PlaybackStatePreparing{song: ${song.title}}';
}

class PlaybackStateLoading extends PlaybackState {
  const PlaybackStateLoading(this.song);
  final Song song;

  @override
  String toString() => 'PlaybackStateLoading{song: ${song.title}}';
}

class PlaybackStateBuffering extends PlaybackState {
  const PlaybackStateBuffering(this.song, this.position);
  final Song song;
  final Duration position;

  @override
  String toString() => 'PlaybackStateBuffering{song: ${song.title}, position: $position}';
}

class PlaybackStatePlaying extends PlaybackState {
  const PlaybackStatePlaying({
    required this.song,
    required this.position,
    required this.duration,
  });

  final Song song;
  final Duration position;
  final Duration duration;

  @override
  String toString() => 'PlaybackStatePlaying{song: ${song.title}, position: $position, duration: $duration}';
}

class PlaybackStatePaused extends PlaybackState {
  const PlaybackStatePaused({
    required this.song,
    required this.position,
    required this.duration,
  });

  final Song song;
  final Duration position;
  final Duration duration;

  @override
  String toString() => 'PlaybackStatePaused{song: ${song.title}, position: $position, duration: $duration}';
}

class PlaybackStateCompleted extends PlaybackState {
  const PlaybackStateCompleted(this.song);
  final Song song;

  @override
  String toString() => 'PlaybackStateCompleted{song: ${song.title}}';
}

class PlaybackStateStopped extends PlaybackState {
  const PlaybackStateStopped();

  @override
  String toString() => 'PlaybackStateStopped';
}

class PlaybackStateDisposed extends PlaybackState {
  const PlaybackStateDisposed();

  @override
  String toString() => 'PlaybackStateDisposed';
}

class PlaybackStateError extends PlaybackState {
  const PlaybackStateError({
    required this.song,
    required this.failure,
    required this.message,
  });

  final Song? song;
  final PlaybackFailure failure;
  final String message;

  @override
  String toString() => 'PlaybackStateError{song: ${song?.title}, failure: $failure, message: $message}';
}
