import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/app_database_provider.dart';
import '../../domain/entities/album.dart';
import '../../domain/entities/artist.dart';
import '../../domain/entities/scan_progress.dart';
import '../../domain/entities/song.dart';
import '../../domain/repositories/library_repository.dart';
import '../mappers/album_mapper.dart';
import '../mappers/artist_mapper.dart';
import '../mappers/song_mapper.dart';
import '../models/parsed_metadata.dart';
import '../services/artwork_cache_service.dart';
import '../services/scanner_pipeline.dart';

part 'library_repository_impl.g.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  LibraryRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<ScanProgress> scanDirectories(List<String> paths) {
    final controller = StreamController<ScanProgress>();

    // Asynchronously run scanning tasks
    Future<void>(() async {
      try {
        // 1. Fetch current database state to support incremental scans
        final dbSongs = await _db.select(_db.songs).get();
        final existingDbFiles = <String, DbFileMetadata>{};
        for (final song in dbSongs) {
          existingDbFiles[song.filePath] = DbFileMetadata(
            fileSize: song.fileSize ?? 0,
            dateModifiedMs: song.dateModified?.millisecondsSinceEpoch ?? 0,
          );
        }

        final pipeline = ScannerPipeline();
        final cacheService = ArtworkCacheService();

        // 2. Start scanning pipeline stream
        final scanStream = pipeline.scan(
          directories: paths,
          existingDbFiles: existingDbFiles,
          onFilesDeleted: (deletedPaths) async {
            if (deletedPaths.isNotEmpty) {
              await _db.transaction(() async {
                for (final path in deletedPaths) {
                  await (_db.delete(_db.songs)..where((t) => t.filePath.equals(path))).go();
                }
              });
            }
          },
          onChunkParsed: (chunk) async {
            await _processParsedChunk(chunk, cacheService);
          },
        );

        // Pipe progress events into controller
        await for (final progress in scanStream) {
          controller.add(progress);
        }
        await controller.close();
      } catch (e) {
        controller.add(
          ScanProgress(
            stage: ScanStage.failed,
            scannedCount: 0,
            totalCount: 0,
            currentFilePath: e.toString(),
          ),
        );
        await controller.close();
      }
    });

    return controller.stream;
  }

  /// Processes and commits a chunk of parsed song metadata inside a SQLite transaction.
  Future<void> _processParsedChunk(
    List<ParsedMetadata> chunk,
    ArtworkCacheService cacheService,
  ) async {
    final artistCompanions = <ArtistsCompanion>[];
    final albumCompanions = <AlbumsCompanion>[];
    final songCompanions = <SongsCompanion>[];

    final insertedArtists = <String>{};
    final insertedAlbums = <String>{};

    for (final meta in chunk) {
      // Deterministic IDs based on names
      final artistName = meta.artist?.trim() ?? 'Unknown Artist';
      final artistId = md5.convert(utf8.encode(artistName.toLowerCase())).toString();

      final albumName = meta.album?.trim() ?? 'Unknown Album';
      final albumId = md5.convert(utf8.encode('${artistId}_${albumName.toLowerCase()}')).toString();

      final songId = md5.convert(utf8.encode(meta.filePath)).toString();

      // Deduplicate additions in the same batch
      if (!insertedArtists.contains(artistId)) {
        artistCompanions.add(
          ArtistsCompanion(
            id: Value(artistId),
            name: Value(artistName),
          ),
        );
        insertedArtists.add(artistId);
      }

      if (!insertedAlbums.contains(albumId)) {
        albumCompanions.add(
          AlbumsCompanion(
            id: Value(albumId),
            name: Value(albumName),
            artistId: Value(artistId),
          ),
        );
        insertedAlbums.add(albumId);
      }

      // Handle Artwork Caching (Deduplicated with SHA-256)
      String? cachedArtworkPath;
      String? cachedArtworkHash;
      if (meta.artworkBytes != null && meta.artworkBytes!.isNotEmpty) {
        try {
          final cacheResult = await cacheService.cacheArtwork(
            meta.artworkBytes!,
            meta.artworkMimeType,
          );
          if (cacheResult != null) {
            cachedArtworkPath = cacheResult.filePath;
            cachedArtworkHash = cacheResult.hash;
          }
        } catch (e) {
          debugPrint('Error caching artwork for ${meta.filePath}: $e');
        }
      }

      songCompanions.add(
        SongsCompanion(
          id: Value(songId),
          title: Value(meta.title ?? 'Unknown Title'),
          albumId: Value(albumId),
          artistId: Value(artistId),
          filePath: Value(meta.filePath),
          duration: Value(meta.durationMs ?? 0),
          trackNumber: Value(meta.trackNumber),
          discNumber: Value(meta.discNumber),
          genre: Value(meta.genre),
          year: Value(meta.year),
          artworkPath: Value(cachedArtworkPath),
          artworkHash: Value(cachedArtworkHash),
          dateModified: Value(meta.dateModified),
          fileSize: Value(meta.fileSize),
        ),
      );
    }

    // SQLite Batch commit inside a transaction
    await _db.transaction(() async {
      for (final companion in artistCompanions) {
        await _db.into(_db.artists).insert(companion, mode: InsertMode.insertOrIgnore);
      }
      for (final companion in albumCompanions) {
        await _db.into(_db.albums).insert(companion, mode: InsertMode.insertOrIgnore);
      }
      await _db.batch((batch) {
        batch.insertAll(_db.songs, songCompanions, mode: InsertMode.insertOrReplace);
      });
    });
  }

  @override
  Future<List<Song>> getAllSongs() async {
    final query = _db.select(_db.songs);
    final results = await query.get();
    return results.map((row) => row.toEntity()).toList();
  }

  @override
  Future<List<Artist>> getAllArtists() async {
    final query = _db.select(_db.artists);
    final results = await query.get();
    return results.map((row) => row.toEntity()).toList();
  }

  @override
  Future<List<Album>> getAllAlbums() async {
    final query = _db.select(_db.albums);
    final results = await query.get();
    return results.map((row) => row.toEntity()).toList();
  }

  @override
  Future<List<Album>> getAlbumsByArtist(String artistId) async {
    final query = _db.select(_db.albums)..where((t) => t.artistId.equals(artistId));
    final results = await query.get();
    return results.map((row) => row.toEntity()).toList();
  }

  @override
  Future<List<Song>> getSongsInFolder(String folderPath) async {
    final query = _db.select(_db.songs)..where((t) => t.filePath.like('$folderPath%'));
    final results = await query.get();
    return results.map((row) => row.toEntity()).toList();
  }

  @override
  Future<Song?> getSongById(String songId) async {
    final query = _db.select(_db.songs)..where((t) => t.id.equals(songId));
    final result = await query.getSingleOrNull();
    return result?.toEntity();
  }

  @override
  Future<Artist?> getArtistById(String artistId) async {
    final query = _db.select(_db.artists)..where((t) => t.id.equals(artistId));
    final result = await query.getSingleOrNull();
    return result?.toEntity();
  }

  @override
  Future<Album?> getAlbumById(String albumId) async {
    final query = _db.select(_db.albums)..where((t) => t.id.equals(albumId));
    final result = await query.getSingleOrNull();
    return result?.toEntity();
  }

  @override
  Future<void> deleteSong(String songId) async {
    final query = _db.delete(_db.songs)..where((t) => t.id.equals(songId));
    await query.go();
  }
}

@riverpod
LibraryRepository libraryRepository(LibraryRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return LibraryRepositoryImpl(db);
}
