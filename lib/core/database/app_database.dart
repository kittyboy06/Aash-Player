import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// ------------------------------------------------------------------------
// DRIFT SCHEMAS
// ------------------------------------------------------------------------

@DataClassName('ArtistModel')
class Artists extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get artworkPath => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('AlbumModel')
class Albums extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get artistId =>
      text().nullable().references(Artists, #id, onDelete: KeyAction.setNull)();
  TextColumn get artworkPath => text().nullable()();
  IntColumn get year => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SongModel')
class Songs extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get albumId =>
      text().nullable().references(Albums, #id, onDelete: KeyAction.setNull)();
  TextColumn get artistId =>
      text().nullable().references(Artists, #id, onDelete: KeyAction.setNull)();
  TextColumn get filePath => text().unique()();
  IntColumn get duration => integer()(); // Milliseconds
  IntColumn get trackNumber => integer().nullable()();
  IntColumn get discNumber => integer().nullable()();
  TextColumn get genre => text().nullable()();
  IntColumn get year => integer().nullable()();
  IntColumn get bitrate => integer().nullable()();
  IntColumn get sampleRate => integer().nullable()();
  TextColumn get artworkPath => text().nullable()();
  TextColumn get artworkHash => text().nullable()();
  DateTimeColumn get dateModified => dateTime().nullable()();
  IntColumn get fileSize => integer().nullable()();
  IntColumn get playCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastPlayed => dateTime().nullable()();
  DateTimeColumn get dateAdded => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LyricModel')
class Lyrics extends Table {
  TextColumn get songId =>
      text().references(Songs, #id, onDelete: KeyAction.cascade)();
  TextColumn get lyricsText => text()();
  TextColumn get syncedLyrics => text().nullable()();

  @override
  Set<Column> get primaryKey => {songId};
}

@DataClassName('PlaylistModel')
class Playlists extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().unique()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get modifiedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PlaylistSongModel')
class PlaylistSongs extends Table {
  TextColumn get playlistId =>
      text().references(Playlists, #id, onDelete: KeyAction.cascade)();
  TextColumn get songId =>
      text().references(Songs, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()(); // Reordering position index

  @override
  Set<Column> get primaryKey => {playlistId, songId};
}

// ------------------------------------------------------------------------
// DATABASE CLASS
// ------------------------------------------------------------------------

@DriftDatabase(
  tables: [Artists, Albums, Songs, Lyrics, Playlists, PlaylistSongs],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        // Enforce SQLite Foreign Key constraints
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}

// Open native SQLite database file connection
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationSupportDirectory();
    final file = File(p.join(dbFolder.path, 'aash_player.db'));

    return NativeDatabase.createInBackground(file);
  });
}
