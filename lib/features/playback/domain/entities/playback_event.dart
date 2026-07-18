import '../../../library/domain/entities/song.dart';
import 'playback_state.dart';
import '../failures/playback_failure.dart';

sealed class PlaybackEvent {
  const PlaybackEvent();
}

class PlaybackStateChanged extends PlaybackEvent {
  const PlaybackStateChanged(this.state);
  final PlaybackState state;

  @override
  String toString() => 'PlaybackStateChanged{state: $state}';
}

class PlaybackPositionChanged extends PlaybackEvent {
  const PlaybackPositionChanged(this.position);
  final Duration position;

  @override
  String toString() => 'PlaybackPositionChanged{position: $position}';
}

class PlaybackDurationChanged extends PlaybackEvent {
  const PlaybackDurationChanged(this.duration);
  final Duration duration;

  @override
  String toString() => 'PlaybackDurationChanged{duration: $duration}';
}

class PlaybackTrackChanged extends PlaybackEvent {
  const PlaybackTrackChanged(this.song);
  final Song? song;

  @override
  String toString() => 'PlaybackTrackChanged{song: ${song?.title}}';
}

class PlaybackErrorOccurred extends PlaybackEvent {
  const PlaybackErrorOccurred(this.failure, this.message);
  final PlaybackFailure failure;
  final String message;

  @override
  String toString() => 'PlaybackErrorOccurred{failure: $failure, message: $message}';
}
