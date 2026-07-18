import '../../domain/entities/playback_state.dart';

abstract class PlaybackPlatformService {
  /// Initializes native platform bindings.
  Future<void> initialize();

  /// Opens a track for playback using the file path.
  Future<void> open(String filePath);

  /// Starts or resumes audio playback.
  Future<void> play();

  /// Pauses audio playback.
  Future<void> pause();

  /// Stops audio playback.
  Future<void> stop();

  /// Seeks to a specific position.
  Future<void> seek(Duration position);

  /// Sets player volume (range 0.0 to 1.0).
  Future<void> setVolume(double volume);

  /// Cleans up platform references, channels, and loops.
  Future<void> dispose();

  /// Pushes positional updates from native engine.
  Stream<Duration> get positionStream;

  /// Pushes duration changes when a new track loads.
  Stream<Duration> get durationStream;

  /// Pushes raw platform state changes.
  Stream<PlaybackState> get stateStream;
}
