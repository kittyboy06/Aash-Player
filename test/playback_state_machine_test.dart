import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:aash_player/features/library/domain/entities/song.dart';
import 'package:aash_player/features/playback/data/repositories/playback_repository_impl.dart';
import 'package:aash_player/features/playback/data/services/playback_platform_service.dart';
import 'package:aash_player/features/playback/domain/entities/playback_event.dart';
import 'package:aash_player/features/playback/domain/entities/playback_state.dart';
import 'package:aash_player/features/playback/domain/failures/playback_failure.dart';

final dummySong = Song(
  id: 'song1',
  title: 'Dummy Track',
  artistId: 'artist1',
  albumId: 'album1',
  filePath: '/path/to/song.mp3',
  duration: const Duration(minutes: 3),
  dateModified: DateTime.fromMillisecondsSinceEpoch(12345678),
  fileSize: 1024,
  playCount: 0,
  dateAdded: DateTime.now(),
);

class MockPlaybackPlatformService implements PlaybackPlatformService {
  final positionController = StreamController<Duration>.broadcast();
  final durationController = StreamController<Duration>.broadcast();
  final stateController = StreamController<PlaybackState>.broadcast();

  bool isInitialized = false;
  bool isDisposed = false;
  String? openedFilePath;
  double volume = 1.0;
  Duration? seekedPosition;
  bool playCalled = false;
  bool pauseCalled = false;
  bool stopCalled = false;

  @override
  Future<void> initialize() async {
    isInitialized = true;
  }

  @override
  Future<void> open(String filePath) async {
    openedFilePath = filePath;
    stateController.add(PlaybackStateLoading(dummySong));
  }

  @override
  Future<void> play() async {
    playCalled = true;
  }

  @override
  Future<void> pause() async {
    pauseCalled = true;
  }

  @override
  Future<void> stop() async {
    stopCalled = true;
  }

  @override
  Future<void> seek(Duration position) async {
    seekedPosition = position;
  }

  @override
  Future<void> setVolume(double volume) async {
    this.volume = volume;
  }

  @override
  Future<void> dispose() async {
    isDisposed = true;
    await positionController.close();
    await durationController.close();
    await stateController.close();
  }

  @override
  Stream<Duration> get positionStream => positionController.stream;

  @override
  Stream<Duration> get durationStream => durationController.stream;

  @override
  Stream<PlaybackState> get stateStream => stateController.stream;
}

void main() {
  late MockPlaybackPlatformService mockService;
  late PlaybackRepositoryImpl repository;

  setUp(() {
    mockService = MockPlaybackPlatformService();
    repository = PlaybackRepositoryImpl(platformService: mockService);
  });

  tearDown(() async {
    await repository.dispose();
  });

  group('Playback State Machine and Repository Tests', () {
    test('Initial state is Idle', () {
      expect(repository.currentSnapshot.state, isA<PlaybackStateIdle>());
      expect(repository.currentSnapshot.currentSong, isNull);
      expect(repository.currentSnapshot.position, equals(Duration.zero));
    });

    test('Open track initiates transition stream correctly', () async {
      final events = <PlaybackEvent>[];
      final subscription = repository.eventStream.listen(events.add);

      // Open a song
      final openFuture = repository.open(dummySong);

      // Verify immediate transition to Preparing
      expect(repository.currentSnapshot.state, isA<PlaybackStatePreparing>());
      expect(repository.currentSnapshot.currentSong, equals(dummySong));

      await openFuture;

      // Yield event queue execution
      await Future<void>.delayed(Duration.zero);

      // Verify state is Loading (emitted by Mock service upon open call)
      expect(repository.currentSnapshot.state, isA<PlaybackStateLoading>());

      expect(events, hasLength(3));
      expect(events[0], isA<PlaybackStateChanged>());
      expect((events[0] as PlaybackStateChanged).state, isA<PlaybackStatePreparing>());
      expect(events[1], isA<PlaybackTrackChanged>());
      expect(events[2], isA<PlaybackStateChanged>());
      expect((events[2] as PlaybackStateChanged).state, isA<PlaybackStateLoading>());

      await subscription.cancel();
    });

    test('Legal transition from Loading to Playing updates snapshot and streams', () async {
      await repository.open(dummySong);

      final events = <PlaybackEvent>[];
      final subscription = repository.eventStream.listen(events.add);

      // Mock platform transitioning to Playing
      mockService.stateController.add(PlaybackStatePlaying(
        song: dummySong,
        position: Duration.zero,
        duration: const Duration(minutes: 3),
      ));

      await Future<void>.delayed(Duration.zero);

      expect(repository.currentSnapshot.state, isA<PlaybackStatePlaying>());
      expect(events, hasLength(1));
      expect(events.first, isA<PlaybackStateChanged>());

      await subscription.cancel();
    });

    test('Invalid transitions are rejected and ignored', () async {
      // From Idle (initial), we try to force PlaybackStatePlaying directly
      mockService.stateController.add(PlaybackStatePlaying(
        song: dummySong,
        position: Duration.zero,
        duration: const Duration(minutes: 3),
      ));

      await Future<void>.delayed(Duration.zero);

      // Should still be Idle!
      expect(repository.currentSnapshot.state, isA<PlaybackStateIdle>());
    });

    test('Volume clamped and synchronized', () async {
      await repository.setVolume(1.5); // Should clamp to 1.0
      expect(repository.currentSnapshot.volume, equals(1.0));
      expect(mockService.volume, equals(1.0));

      await repository.setVolume(-0.2); // Should clamp to 0.0
      expect(repository.currentSnapshot.volume, equals(0.0));
      expect(mockService.volume, equals(0.0));
    });

    test('Position and Duration stream synchronization', () async {
      await repository.open(dummySong);
      
      // transition to playing first
      mockService.stateController.add(PlaybackStatePlaying(
        song: dummySong,
        position: Duration.zero,
        duration: const Duration(minutes: 3),
      ));
      await Future<void>.delayed(Duration.zero);

      final events = <PlaybackEvent>[];
      final subscription = repository.eventStream.listen(events.add);

      // Update position
      mockService.positionController.add(const Duration(seconds: 15));
      // Update duration
      mockService.durationController.add(const Duration(seconds: 180));

      await Future<void>.delayed(Duration.zero);

      expect(repository.currentSnapshot.position, equals(const Duration(seconds: 15)));
      expect(repository.currentSnapshot.duration, equals(const Duration(seconds: 180)));

      expect(events, hasLength(2));
      expect(events[0], isA<PlaybackPositionChanged>());
      expect(events[1], isA<PlaybackDurationChanged>());

      await subscription.cancel();
    });

    test('Stop transition updates snapshot and stops platform engine', () async {
      await repository.open(dummySong);
      mockService.stateController.add(PlaybackStatePlaying(
        song: dummySong,
        position: Duration.zero,
        duration: const Duration(minutes: 3),
      ));
      await Future<void>.delayed(Duration.zero);

      await repository.stop();

      expect(repository.currentSnapshot.state, isA<PlaybackStateStopped>());
      expect(repository.currentSnapshot.currentSong, isNull);
      expect(mockService.stopCalled, isTrue);
    });
  });
}
