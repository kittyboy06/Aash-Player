import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart' hide Lyrics;
import '../../domain/entities/lyrics.dart';

extension LyricModelMapper on LyricModel {
  Lyrics toEntity() {
    return Lyrics(
      songId: songId,
      lyricsText: lyricsText,
      syncedLyrics: syncedLyrics,
    );
  }
}

extension LyricsEntityMapper on Lyrics {
  LyricsCompanion toCompanion(bool isInsert) {
    return LyricsCompanion(
      songId: Value(songId),
      lyricsText: Value(lyricsText),
      syncedLyrics: Value(syncedLyrics),
    );
  }
}
