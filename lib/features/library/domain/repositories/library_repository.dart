import '../entities/song.dart';
import '../entities/album.dart';
import '../entities/artist.dart';
import '../entities/scan_progress.dart';

abstract class LibraryRepository {
  Stream<ScanProgress> scanDirectories(List<String> paths);
  Future<List<Song>> getAllSongs();
  Future<List<Artist>> getAllArtists();
  Future<List<Album>> getAllAlbums();
  Future<List<Album>> getAlbumsByArtist(String artistId);
  Future<List<Song>> getSongsInFolder(String folderPath);
  Future<Song?> getSongById(String songId);
  Future<Artist?> getArtistById(String artistId);
  Future<Album?> getAlbumById(String albumId);
  Future<void> deleteSong(String songId);
}
