import '../../../library/domain/entities/song.dart';
import 'playback_state.dart';

class PlaybackSnapshot {
  const PlaybackSnapshot({
    required this.state,
    this.currentSong,
    required this.position,
    required this.duration,
    required this.volume,
  });

  factory PlaybackSnapshot.initial() => const PlaybackSnapshot(
        state: PlaybackStateIdle(),
        currentSong: null,
        position: Duration.zero,
        duration: Duration.zero,
        volume: 1.0,
      );

  final PlaybackState state;
  final Song? currentSong;
  final Duration position;
  final Duration duration;
  final double volume;

  PlaybackSnapshot copyWith({
    PlaybackState? state,
    Song? Function()? currentSong,
    Duration? position,
    Duration? duration,
    double? volume,
  }) {
    return PlaybackSnapshot(
      state: state ?? this.state,
      currentSong: currentSong != null ? currentSong() : this.currentSong,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      volume: volume ?? this.volume,
    );
  }

  @override
  String toString() {
    return 'PlaybackSnapshot{state: $state, currentSong: ${currentSong?.title}, position: $position, duration: $duration, volume: $volume}';
  }
}
