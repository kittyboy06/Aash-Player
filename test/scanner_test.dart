import 'dart:io';
import 'dart:typed_data';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aash_player/core/database/app_database.dart';
import 'package:aash_player/features/library/data/repositories/library_repository_impl.dart';
import 'package:aash_player/features/library/data/services/artwork_cache_service.dart';
import 'package:aash_player/features/library/domain/entities/scan_progress.dart';

String _normalizePath(String path) {
  return path.replaceAll('\\', '/');
}

void main() {
  late Directory tempDir;
  late AppDatabase database;
  late LibraryRepositoryImpl libraryRepository;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('aash_player_test');
    database = AppDatabase(NativeDatabase.memory());
    libraryRepository = LibraryRepositoryImpl(database);
  });

  tearDown(() async {
    await database.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('ArtworkCacheService Tests', () {
    test('Caches and deduplicates artwork bytes using SHA-256', () async {
      final cacheDir = Directory('${tempDir.path}/artwork_cache');
      final cacheService = ArtworkCacheService(customBaseDir: cacheDir);

      final dummyBytes1 = Uint8List.fromList([1, 2, 3, 4, 5]);
      final dummyBytes2 = Uint8List.fromList([1, 2, 3, 4, 5]); // Identical
      final dummyBytes3 = Uint8List.fromList([5, 4, 3, 2, 1]); // Different

      // Cache first image
      final res1 = await cacheService.cacheArtwork(dummyBytes1, 'image/jpeg');
      expect(res1, isNotNull);
      expect(res1!.hash, isNotEmpty);
      expect(File(res1.filePath).existsSync(), isTrue);

      // Cache identical image (should deduplicate)
      final res2 = await cacheService.cacheArtwork(dummyBytes2, 'image/jpeg');
      expect(res2, isNotNull);
      expect(res2!.hash, equals(res1.hash));
      expect(res2.filePath, equals(res1.filePath));

      // Cache different image
      final res3 = await cacheService.cacheArtwork(dummyBytes3, 'image/png');
      expect(res3, isNotNull);
      expect(res3!.hash, isNot(equals(res1.hash)));
      expect(res3.filePath.endsWith('.png'), isTrue);
      expect(File(res3.filePath).existsSync(), isTrue);
    });
  });

  group('ScannerPipeline and Repository Integration Tests', () {
    test('Recursively scans directory and performs incremental sync', () async {
      // 1. Create temporary music folder structure
      final musicDir = Directory('${tempDir.path}/Music');
      musicDir.createSync();

      final song1 = File('${musicDir.path}/song1.mp3')..writeAsStringSync('dummy content 1');
      final song2 = File('${musicDir.path}/song2.flac')..writeAsStringSync('dummy content 2');
      // Subdirectory song
      final subDir = Directory('${musicDir.path}/Subdir')..createSync();
      final song3 = File('${subDir.path}/song3.m4a')..writeAsStringSync('dummy content 3');

      // 2. Perform first scan
      final progressList = <ScanProgress>[];
      final scanStream = libraryRepository.scanDirectories([musicDir.path]);

      await for (final progress in scanStream) {
        progressList.add(progress);
      }

      // Verify progress states and complete
      expect(progressList, isNotEmpty);
      expect(progressList.last.stage, equals(ScanStage.complete));

      // Verify that database has indexed all 3 songs
      final songs = await libraryRepository.getAllSongs();
      expect(songs, hasLength(3));

      final filePaths = songs.map((s) => _normalizePath(s.filePath)).toSet();
      expect(filePaths.contains(_normalizePath(song1.path)), isTrue);
      expect(filePaths.contains(_normalizePath(song2.path)), isTrue);
      expect(filePaths.contains(_normalizePath(song3.path)), isTrue);

      // Verify default fallback title mapping matches filename
      final s1 = songs.firstWhere((s) => _normalizePath(s.filePath) == _normalizePath(song1.path));
      expect(s1.title, equals('song1'));

      // 3. Incremental Rescan - No changes
      progressList.clear();
      final scanStream2 = libraryRepository.scanDirectories([musicDir.path]);
      await for (final progress in scanStream2) {
        progressList.add(progress);
      }
      expect(progressList.last.stage, equals(ScanStage.complete));

      final songsAfterRescan = await libraryRepository.getAllSongs();
      expect(songsAfterRescan, hasLength(3));

      // 4. Incremental Rescan - File deletion
      song2.deleteSync();

      progressList.clear();
      final scanStream3 = libraryRepository.scanDirectories([musicDir.path]);
      await for (final progress in scanStream3) {
        progressList.add(progress);
      }
      expect(progressList.last.stage, equals(ScanStage.complete));

      final songsAfterDelete = await libraryRepository.getAllSongs();
      expect(songsAfterDelete, hasLength(2));
      expect(songsAfterDelete.any((s) => _normalizePath(s.filePath) == _normalizePath(song2.path)), isFalse);

      // 5. Incremental Rescan - File modification (change size)
      song1.writeAsStringSync('modified content which is much larger now');

      progressList.clear();
      final scanStream4 = libraryRepository.scanDirectories([musicDir.path]);
      await for (final progress in scanStream4) {
        progressList.add(progress);
      }
      expect(progressList.last.stage, equals(ScanStage.complete));

      final songsAfterModify = await libraryRepository.getAllSongs();
      expect(songsAfterModify, hasLength(2));
      final s1Modified = songsAfterModify.firstWhere((s) => _normalizePath(s.filePath) == _normalizePath(song1.path));
      expect(s1Modified.fileSize, isNot(equals(s1.fileSize)));
    });
  });
}
