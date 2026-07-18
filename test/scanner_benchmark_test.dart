// ignore_for_file: avoid_print
import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aash_player/core/database/app_database.dart';
import 'package:aash_player/features/library/data/repositories/library_repository_impl.dart';
import 'package:aash_player/features/library/domain/entities/scan_progress.dart';

void main() {
  test('Benchmark Full Scan and Incremental Sync on Demo/Songs', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final libraryRepository = LibraryRepositoryImpl(database);

    final demoDir = Directory('Demo/Songs');
    if (!demoDir.existsSync()) {
      fail('Demo/Songs directory not found in the workspace root.');
    }

    print('==================================================');
    print('Starting Benchmark Scan on Demo/Songs (353 files)...');
    print('==================================================');

    final stopwatch = Stopwatch()..start();

    // 1. First Full Scan
    final progressList1 = <ScanProgress>[];
    await for (final progress in libraryRepository.scanDirectories([demoDir.path])) {
      progressList1.add(progress);
      if (progress.stage == ScanStage.extracting && progress.scannedCount % 50 == 0) {
        print('Full Scan progress: ${progress.scannedCount}/${progress.totalCount} files...');
      }
    }

    stopwatch.stop();
    final fullScanMs = stopwatch.elapsedMilliseconds;

    final songs = await libraryRepository.getAllSongs();
    final artists = await libraryRepository.getAllArtists();
    final albums = await libraryRepository.getAllAlbums();

    print('--------------------------------------------------');
    print('Full Scan completed in ${fullScanMs}ms');
    print('Songs parsed & cached: ${songs.length}');
    print('Unique Artists indexed: ${artists.length}');
    print('Unique Albums indexed: ${albums.length}');
    print('--------------------------------------------------');

    expect(songs.length, equals(353));
    expect(progressList1.last.stage, equals(ScanStage.complete));
    expect(fullScanMs, lessThan(3000)); // Performance Budget: < 3.0s

    // 2. Incremental Scan (0 changes)
    stopwatch.reset();
    stopwatch.start();

    final progressList2 = <ScanProgress>[];
    await for (final progress in libraryRepository.scanDirectories([demoDir.path])) {
      progressList2.add(progress);
    }

    stopwatch.stop();
    final incrementalScanMs = stopwatch.elapsedMilliseconds;

    print('Incremental Scan (0 changes) completed in ${incrementalScanMs}ms');
    print('--------------------------------------------------');

    expect(progressList2.last.stage, equals(ScanStage.complete));
    expect(incrementalScanMs, lessThan(500)); // Performance Budget: < 500ms

    await database.close();
  });
}
