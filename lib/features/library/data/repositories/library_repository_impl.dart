import 'package:drift/drift.dart';
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

part 'library_repository_impl.g.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  LibraryRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<ScanProgress> scanDirectories(List<String> paths) {
    // Note: The actual background isolate scanning pipeline will be implemented in Milestone 3.
    // For now, return a placeholder stream that immediately completes.
    return Stream.value(
      const ScanProgress(
        scannedCount: 0,
        totalCount: 0,
        currentFilePath: '',
        isComplete: true,
      ),
    );
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
    final query = _db.select(_db.albums)
      ..where((t) => t.artistId.equals(artistId));
    final results = await query.get();
    return results.map((row) => row.toEntity()).toList();
  }

  @override
  Future<List<Song>> getSongsInFolder(String folderPath) async {
    final query = _db.select(_db.songs)
      ..where((t) => t.filePath.like('$folderPath%'));
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
  // Assuming AppDatabase provider is registered or can be resolved.
  // Since we bootstrap AppDatabase as a singleton, we can resolve it from ref.watch or inject it.
  // Let's assume we have an appDatabaseProvider. Let's write it if not already present.
  final db = ref.watch(appDatabaseProvider);
  return LibraryRepositoryImpl(db);
}
