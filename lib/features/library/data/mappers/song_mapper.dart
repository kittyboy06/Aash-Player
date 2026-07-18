import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/song.dart';

extension SongModelMapper on SongModel {
  Song toEntity() {
    return Song(
      id: id,
      title: title,
      albumId: albumId,
      artistId: artistId,
      filePath: filePath,
      duration: Duration(milliseconds: duration),
      trackNumber: trackNumber,
      discNumber: discNumber,
      genre: genre,
      year: year,
      bitrate: bitrate,
      sampleRate: sampleRate,
      artworkPath: artworkPath,
      artworkHash: artworkHash,
      dateModified: dateModified,
      fileSize: fileSize,
      playCount: playCount,
      lastPlayed: lastPlayed,
      dateAdded: dateAdded,
    );
  }
}

extension SongEntityMapper on Song {
  SongsCompanion toCompanion(bool isInsert) {
    return SongsCompanion(
      id: Value(id),
      title: Value(title),
      albumId: Value(albumId),
      artistId: Value(artistId),
      filePath: Value(filePath),
      duration: Value(duration.inMilliseconds),
      trackNumber: Value(trackNumber),
      discNumber: Value(discNumber),
      genre: Value(genre),
      year: Value(year),
      bitrate: Value(bitrate),
      sampleRate: Value(sampleRate),
      artworkPath: Value(artworkPath),
      artworkHash: Value(artworkHash),
      dateModified: Value(dateModified),
      fileSize: Value(fileSize),
      playCount: Value(playCount),
      lastPlayed: Value(lastPlayed),
      dateAdded: Value(dateAdded),
    );
  }
}
