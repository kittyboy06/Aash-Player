import '../entities/playlist.dart';

abstract class PlaylistRepository {
  Future<Playlist> createPlaylist(String name);
  Future<void> deletePlaylist(String playlistId);
  Future<void> addSongToPlaylist(String playlistId, String songId);
  Future<void> removeSongFromPlaylist(String playlistId, String songId);
  Future<void> reorderSong(String playlistId, int oldIndex, int newIndex);
  Stream<List<Playlist>> watchPlaylists();
  Future<Playlist?> getPlaylistById(String playlistId);
}
