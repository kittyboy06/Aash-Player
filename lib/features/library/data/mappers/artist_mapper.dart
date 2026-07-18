import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/artist.dart';

extension ArtistModelMapper on ArtistModel {
  Artist toEntity() {
    return Artist(id: id, name: name, artworkPath: artworkPath);
  }
}

extension ArtistEntityMapper on Artist {
  ArtistsCompanion toCompanion(bool isInsert) {
    return ArtistsCompanion(
      id: Value(id),
      name: Value(name),
      artworkPath: Value(artworkPath),
    );
  }
}
