import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../library/domain/entities/song.dart';
import '../../domain/entities/playback_event.dart';
import '../../domain/entities/playback_snapshot.dart';
import '../../domain/entities/playback_state.dart';
import '../../domain/failures/playback_failure.dart';
import '../../domain/repositories/playback_repository.dart';
import '../services/playback_platform_service.dart';

import '../services/android_playback_service.dart';
import '../services/windows_playback_service.dart';

part 'playback_repository_impl.g.dart';

class PlaybackRepositoryImpl implements PlaybackRepository {
  PlaybackRepositoryImpl({PlaybackPlatformService? platformService}) {
    _service = platformService ?? _resolvePlatformService();
    _service.initialize();
    _initStreams();
  }

  late final PlaybackPlatformService _service;
  final _eventController = StreamController<PlaybackEvent>.broadcast();
  var _snapshot = PlaybackSnapshot.initial();
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  static PlaybackPlatformService _resolvePlatformService() {
    if (Platform.isWindows) return WindowsPlaybackService();
    if (Platform.isAndroid) return AndroidPlaybackService();
    throw UnimplementedError('Platform playback service not supported');
  }

  void _initStreams() {
    // 1. Listen to raw platform state changes
    _subscriptions.add(
      _service.stateStream.listen(
        (platformState) {
          _transitionTo(platformState);
        },
        onError: (Object err) {
          _transitionTo(
            PlaybackStateError(
              song: _snapshot.currentSong,
              failure: PlaybackFailure.unknown,
              message: err.toString(),
            ),
          );
        },
      ),
    );

    // 2. Listen to position streams
    _subscriptions.add(
      _service.positionStream.listen((pos) {
        if (_snapshot.state is PlaybackStatePlaying || _snapshot.state is PlaybackStatePaused) {
          _snapshot = _snapshot.copyWith(position: pos);
          _eventController.add(PlaybackPositionChanged(pos));
        }
      }),
    );

    // 3. Listen to duration streams
    _subscriptions.add(
      _service.durationStream.listen((dur) {
        if (_snapshot.state is PlaybackStatePlaying || _snapshot.state is PlaybackStatePaused) {
          _snapshot = _snapshot.copyWith(duration: dur);
          _eventController.add(PlaybackDurationChanged(dur));
        }
      }),
    );
  }

  void _transitionTo(PlaybackState nextState) {
    // Check state transition constraints
    if (!_isValidTransition(_snapshot.state, nextState)) {
      debugPrint('Warning: Invalid playback state transition from ${_snapshot.state} to $nextState ignored.');
      return;
    }

    // Set/clear current song based on next state
    Song? nextSong = _snapshot.currentSong;
    if (nextState is PlaybackStateIdle || nextState is PlaybackStateStopped || nextState is PlaybackStateDisposed) {
      nextSong = null;
    } else if (nextState is PlaybackStatePreparing) {
      nextSong = nextState.song;
    }

    _snapshot = _snapshot.copyWith(
      state: nextState,
      currentSong: () => nextSong,
      position: nextState is PlaybackStatePreparing ? Duration.zero : _snapshot.position,
      duration: nextState is PlaybackStatePreparing ? Duration.zero : _snapshot.duration,
    );

    _eventController.add(PlaybackStateChanged(nextState));

    if (nextState is PlaybackStatePreparing) {
      _eventController.add(PlaybackTrackChanged(nextSong));
    }
  }

  bool _isValidTransition(PlaybackState from, PlaybackState to) {
    if (to is PlaybackStateDisposed) return true;
    if (to is PlaybackStateError) return true;

    // Transition table check
    return switch (from) {
      PlaybackStateIdle() => to is PlaybackStatePreparing,
      PlaybackStatePreparing() => to is PlaybackStateLoading || to is PlaybackStateStopped,
      PlaybackStateLoading() => to is PlaybackStatePlaying || to is PlaybackStatePaused || to is PlaybackStateStopped,
      PlaybackStateBuffering() => to is PlaybackStatePlaying || to is PlaybackStatePaused || to is PlaybackStateStopped,
      PlaybackStatePlaying() => to is PlaybackStatePaused || to is PlaybackStateCompleted || to is PlaybackStateStopped || to is PlaybackStateBuffering,
      PlaybackStatePaused() => to is PlaybackStatePlaying || to is PlaybackStateStopped,
      PlaybackStateCompleted() => to is PlaybackStatePreparing || to is PlaybackStateStopped || to is PlaybackStateIdle,
      PlaybackStateStopped() => to is PlaybackStatePreparing || to is PlaybackStateIdle,
      PlaybackStateDisposed() => false, // Disposed is final
      PlaybackStateError() => to is PlaybackStatePreparing || to is PlaybackStateStopped || to is PlaybackStateIdle,
    };
  }

  @override
  PlaybackSnapshot get currentSnapshot => _snapshot;

  @override
  Stream<PlaybackEvent> get eventStream => _eventController.stream;

  @override
  Future<void> open(Song song) async {
    _transitionTo(PlaybackStatePreparing(song));
    try {
      await _service.open(song);
    } catch (e) {
      _transitionTo(
        PlaybackStateError(
          song: song,
          failure: PlaybackFailure.fileNotFound,
          message: e.toString(),
        ),
      );
      rethrow;
    }
  }

  @override
  Future<void> play() async {
    if (_snapshot.state is PlaybackStatePaused || _snapshot.state is PlaybackStateLoading || _snapshot.state is PlaybackStateBuffering || _snapshot.state is PlaybackStateCompleted) {
      await _service.play();
    }
  }

  @override
  Future<void> pause() async {
    if (_snapshot.state is PlaybackStatePlaying || _snapshot.state is PlaybackStateBuffering) {
      await _service.pause();
    }
  }

  @override
  Future<void> stop() async {
    await _service.stop();
    _transitionTo(const PlaybackStateStopped());
  }

  @override
  Future<void> seek(Duration position) async {
    if (_snapshot.state is PlaybackStatePlaying || _snapshot.state is PlaybackStatePaused || _snapshot.state is PlaybackStateCompleted) {
      await _service.seek(position);
    }
  }

  @override
  Future<void> setVolume(double volume) async {
    final clamped = volume.clamp(0.0, 1.0);
    await _service.setVolume(clamped);
    _snapshot = _snapshot.copyWith(volume: clamped);
  }

  Future<void> dispose() async {
    for (final sub in _subscriptions) {
      await sub.cancel();
    }
    await _service.dispose();
    _transitionTo(const PlaybackStateDisposed());
    await _eventController.close();
  }
}

@riverpod
PlaybackRepository playbackRepository(PlaybackRepositoryRef ref) {
  final repo = PlaybackRepositoryImpl();
  ref.onDispose(() {
    repo.dispose();
  });
  return repo;
}
