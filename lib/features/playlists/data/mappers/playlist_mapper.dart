import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../library/domain/entities/song.dart';
import '../../domain/entities/playlist.dart';

extension PlaylistModelMapper on PlaylistModel {
  Playlist toEntity({List<Song> songs = const []}) {
    return Playlist(
      id: id,
      name: name,
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      songs: songs,
    );
  }
}

extension PlaylistEntityMapper on Playlist {
  PlaylistsCompanion toCompanion(bool isInsert) {
    return PlaylistsCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
      modifiedAt: Value(modifiedAt),
    );
  }
}
