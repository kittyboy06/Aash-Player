import '../../../library/domain/entities/song.dart';
import '../entities/playback_event.dart';

abstract class PlaybackRepository {
  /// Opens a track for playback.
  /// Throws [PlaybackFailure] on error.
  Future<void> open(Song song);

  /// Starts or resumes playback.
  Future<void> play();

  /// Pauses playback.
  Future<void> pause();

  /// Stops playback.
  Future<void> stop();

  /// Seeks to a specific position in the track.
  Future<void> seek(Duration position);

  /// Sets the volume (range 0.0 to 1.0).
  Future<void> setVolume(double volume);

  /// Reactive stream broadcasting all playback status and position updates.
  Stream<PlaybackEvent> get eventStream;
}
