import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/app_database_provider.dart';
import '../../../library/data/mappers/song_mapper.dart';
import '../../domain/entities/playlist.dart';
import '../../domain/repositories/playlist_repository.dart';
import '../mappers/playlist_mapper.dart';

part 'playlist_repository_impl.g.dart';

class PlaylistRepositoryImpl implements PlaylistRepository {
  PlaylistRepositoryImpl(this._db);

  final AppDatabase _db;

  String _generateId() {
    return '${DateTime.now().microsecondsSinceEpoch}_${(1000 + (DateTime.now().microsecondsSinceEpoch % 9000))}';
  }

  @override
  Future<Playlist> createPlaylist(String name) async {
    final id = _generateId();
    final now = DateTime.now();
    final model = PlaylistModel(
      id: id,
      name: name,
      createdAt: now,
      modifiedAt: now,
    );
    await _db.into(_db.playlists).insert(model);
    return model.toEntity();
  }

  @override
  Future<void> deletePlaylist(String playlistId) async {
    final query = _db.delete(_db.playlists)
      ..where((t) => t.id.equals(playlistId));
    await query.go();
  }

  @override
  Future<void> addSongToPlaylist(String playlistId, String songId) async {
    await _db.transaction(() async {
      final query = _db.select(_db.playlistSongs)
        ..where((t) => t.playlistId.equals(playlistId))
        ..orderBy([
          (t) => OrderingTerm(expression: t.position, mode: OrderingMode.desc),
        ])
        ..limit(1);
      final lastSong = await query.getSingleOrNull();
      final nextPosition = (lastSong?.position ?? -1) + 1;
      await _db
          .into(_db.playlistSongs)
          .insert(
            PlaylistSongModel(
              playlistId: playlistId,
              songId: songId,
              position: nextPosition,
            ),
          );
      // Update modifiedAt on playlist
      await (_db.update(_db.playlists)..where((t) => t.id.equals(playlistId)))
          .write(PlaylistsCompanion(modifiedAt: Value(DateTime.now())));
    });
  }

  @override
  Future<void> removeSongFromPlaylist(String playlistId, String songId) async {
    await _db.transaction(() async {
      await (_db.delete(_db.playlistSongs)..where(
            (t) => t.playlistId.equals(playlistId) & t.songId.equals(songId),
          ))
          .go();
      // Re-index remaining positions
      final remaining =
          await (_db.select(_db.playlistSongs)
                ..where((t) => t.playlistId.equals(playlistId))
                ..orderBy([(t) => OrderingTerm(expression: t.position)]))
              .get();
      for (int i = 0; i < remaining.length; i++) {
        await (_db.update(_db.playlistSongs)..where(
              (t) =>
                  t.playlistId.equals(playlistId) &
                  t.songId.equals(remaining[i].songId),
            ))
            .write(PlaylistSongsCompanion(position: Value(i)));
      }
      // Update modifiedAt on playlist
      await (_db.update(_db.playlists)..where((t) => t.id.equals(playlistId)))
          .write(PlaylistsCompanion(modifiedAt: Value(DateTime.now())));
    });
  }

  @override
  Future<void> reorderSong(
    String playlistId,
    int oldIndex,
    int newIndex,
  ) async {
    await _db.transaction(() async {
      final songs =
          await (_db.select(_db.playlistSongs)
                ..where((t) => t.playlistId.equals(playlistId))
                ..orderBy([(t) => OrderingTerm(expression: t.position)]))
              .get();
      if (oldIndex < 0 ||
          oldIndex >= songs.length ||
          newIndex < 0 ||
          newIndex >= songs.length) {
        return;
      }
      final moved = songs.removeAt(oldIndex);
      songs.insert(newIndex, moved);
      for (int i = 0; i < songs.length; i++) {
        await (_db.update(_db.playlistSongs)..where(
              (t) =>
                  t.playlistId.equals(playlistId) &
                  t.songId.equals(songs[i].songId),
            ))
            .write(PlaylistSongsCompanion(position: Value(i)));
      }
      // Update modifiedAt on playlist
      await (_db.update(_db.playlists)..where((t) => t.id.equals(playlistId)))
          .write(PlaylistsCompanion(modifiedAt: Value(DateTime.now())));
    });
  }

  @override
  Future<Playlist?> getPlaylistById(String playlistId) async {
    final playlistRow = await (_db.select(
      _db.playlists,
    )..where((t) => t.id.equals(playlistId))).getSingleOrNull();
    if (playlistRow == null) return null;
    final query =
        _db.select(_db.playlistSongs).join([
            innerJoin(
              _db.songs,
              _db.songs.id.equalsExp(_db.playlistSongs.songId),
            ),
          ])
          ..where(_db.playlistSongs.playlistId.equals(playlistId))
          ..orderBy([OrderingTerm(expression: _db.playlistSongs.position)]);
    final rows = await query.get();
    final songs = rows.map((r) => r.readTable(_db.songs).toEntity()).toList();
    return playlistRow.toEntity(songs: songs);
  }

  @override
  Stream<List<Playlist>> watchPlaylists() {
    return _db.select(_db.playlists).watch().asyncMap((playlists) async {
      final list = <Playlist>[];
      for (final p in playlists) {
        final query =
            _db.select(_db.playlistSongs).join([
                innerJoin(
                  _db.songs,
                  _db.songs.id.equalsExp(_db.playlistSongs.songId),
                ),
              ])
              ..where(_db.playlistSongs.playlistId.equals(p.id))
              ..orderBy([OrderingTerm(expression: _db.playlistSongs.position)]);
        final rows = await query.get();
        final songs = rows
            .map((r) => r.readTable(_db.songs).toEntity())
            .toList();
        list.add(p.toEntity(songs: songs));
      }
      return list;
    });
  }
}

@riverpod
PlaylistRepository playlistRepository(PlaylistRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return PlaylistRepositoryImpl(db);
}
