import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aash_player/core/database/app_database.dart';
import 'package:aash_player/features/library/data/repositories/library_repository_impl.dart';
import 'package:aash_player/features/library/domain/entities/song.dart';
import 'package:aash_player/features/playlists/data/repositories/playlist_repository_impl.dart';

void main() {
  late AppDatabase database;
  late LibraryRepositoryImpl libraryRepository;
  late PlaylistRepositoryImpl playlistRepository;

  setUp(() {
    // Initialize drift database in memory for testing
    database = AppDatabase(NativeDatabase.memory());
    libraryRepository = LibraryRepositoryImpl(database);
    playlistRepository = PlaylistRepositoryImpl(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('LibraryRepository Tests', () {
    test('Can query empty database', () async {
      final songs = await libraryRepository.getAllSongs();
      expect(songs, isEmpty);

      final artists = await libraryRepository.getAllArtists();
      expect(artists, isEmpty);

      final albums = await libraryRepository.getAllAlbums();
      expect(albums, isEmpty);
    });

    test('Can insert and retrieve songs, artists, and albums', () async {
      // 1. Insert Artist
      const artistId = 'artist_1';
      await database
          .into(database.artists)
          .insert(const ArtistModel(id: artistId, name: 'Test Artist'));

      // 2. Insert Album
      const albumId = 'album_1';
      await database
          .into(database.albums)
          .insert(
            const AlbumModel(
              id: albumId,
              name: 'Test Album',
              artistId: artistId,
            ),
          );

      // 3. Insert Song
      const songId = 'song_1';
      final songModel = SongModel(
        id: songId,
        title: 'Test Song',
        albumId: albumId,
        artistId: artistId,
        filePath: '/music/test_song.mp3',
        duration: 180000, // 3 minutes
        dateAdded: DateTime.now(),
        playCount: 0,
      );
      await database.into(database.songs).insert(songModel);

      // Verify retrieval
      final songs = await libraryRepository.getAllSongs();
      expect(songs, hasLength(1));
      expect(songs.first.id, songId);
      expect(songs.first.title, 'Test Song');
      expect(songs.first.duration, const Duration(minutes: 3));

      final artists = await libraryRepository.getAllArtists();
      expect(artists, hasLength(1));
      expect(artists.first.id, artistId);

      final albums = await libraryRepository.getAlbumsByArtist(artistId);
      expect(albums, hasLength(1));
      expect(albums.first.id, albumId);

      final songsInFolder = await libraryRepository.getSongsInFolder('/music');
      expect(songsInFolder, hasLength(1));

      // Delete song
      await libraryRepository.deleteSong(songId);
      final songsAfterDelete = await libraryRepository.getAllSongs();
      expect(songsAfterDelete, isEmpty);
    });
  });

  group('PlaylistRepository Tests', () {
    test('Can create, delete, and reorder playlists', () async {
      // Create playlist
      final playlist = await playlistRepository.createPlaylist('Favorites');
      expect(playlist.name, 'Favorites');

      // Add a song to database first
      const songId = 'song_1';
      await database
          .into(database.songs)
          .insert(
            SongModel(
              id: songId,
              title: 'Song 1',
              filePath: '/music/song1.mp3',
              duration: 150000,
              dateAdded: DateTime.now(),
              playCount: 0,
            ),
          );

      // Add song to playlist
      await playlistRepository.addSongToPlaylist(playlist.id, songId);

      // Verify playlist by ID
      final retrievedPlaylist = await playlistRepository.getPlaylistById(
        playlist.id,
      );
      expect(retrievedPlaylist, isNotNull);
      expect(retrievedPlaylist!.songs, hasLength(1));
      expect(retrievedPlaylist.songs.first.id, songId);

      // Delete playlist
      await playlistRepository.deletePlaylist(playlist.id);
      final deletedPlaylist = await playlistRepository.getPlaylistById(
        playlist.id,
      );
      expect(deletedPlaylist, isNull);
    });

    test('Playlist reordering works correctly', () async {
      final playlist = await playlistRepository.createPlaylist('Queue');

      // Add three songs
      for (int i = 1; i <= 3; i++) {
        final songId = 'song_$i';
        await database
            .into(database.songs)
            .insert(
              SongModel(
                id: songId,
                title: 'Song $i',
                filePath: '/music/song$i.mp3',
                duration: 150000,
                dateAdded: DateTime.now(),
                playCount: 0,
              ),
            );
        await playlistRepository.addSongToPlaylist(playlist.id, songId);
      }

      // Verify initial order
      var p = await playlistRepository.getPlaylistById(playlist.id);
      expect(p!.songs.map((s) => s.id), ['song_1', 'song_2', 'song_3']);

      // Reorder song_1 from index 0 to index 2
      await playlistRepository.reorderSong(playlist.id, 0, 2);

      // Verify new order
      p = await playlistRepository.getPlaylistById(playlist.id);
      expect(p!.songs.map((s) => s.id), ['song_2', 'song_3', 'song_1']);
    });
  });
}
