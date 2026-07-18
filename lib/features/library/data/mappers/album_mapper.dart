import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/album.dart';

extension AlbumModelMapper on AlbumModel {
  Album toEntity() {
    return Album(
      id: id,
      name: name,
      artistId: artistId,
      artworkPath: artworkPath,
      year: year,
    );
  }
}

extension AlbumEntityMapper on Album {
  AlbumsCompanion toCompanion(bool isInsert) {
    return AlbumsCompanion(
      id: Value(id),
      name: Value(name),
      artistId: Value(artistId),
      artworkPath: Value(artworkPath),
      year: Value(year),
    );
  }
}
