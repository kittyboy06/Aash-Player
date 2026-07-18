class Album {
  const Album({
    required this.id,
    required this.name,
    this.artistId,
    this.artworkPath,
    this.year,
  });

  final String id;
  final String name;
  final String? artistId;
  final String? artworkPath;
  final int? year;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Album &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          artistId == other.artistId &&
          artworkPath == other.artworkPath &&
          year == other.year;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      artistId.hashCode ^
      artworkPath.hashCode ^
      year.hashCode;

  @override
  String toString() {
    return 'Album{id: $id, name: $name, artistId: $artistId, artworkPath: $artworkPath, year: $year}';
  }
}
