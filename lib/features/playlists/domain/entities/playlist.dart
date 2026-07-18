import '../../../library/domain/entities/song.dart';

class Playlist {
  const Playlist({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.modifiedAt,
    this.songs = const [],
  });

  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final List<Song> songs;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Playlist &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          createdAt == other.createdAt &&
          modifiedAt == other.modifiedAt &&
          songs == other.songs;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      createdAt.hashCode ^
      modifiedAt.hashCode ^
      songs.hashCode;

  @override
  String toString() {
    return 'Playlist{id: $id, name: $name, createdAt: $createdAt, modifiedAt: $modifiedAt, songsCount: ${songs.length}}';
  }
}
