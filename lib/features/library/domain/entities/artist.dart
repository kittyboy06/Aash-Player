class Artist {
  const Artist({required this.id, required this.name, this.artworkPath});

  final String id;
  final String name;
  final String? artworkPath;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Artist &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          artworkPath == other.artworkPath;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ artworkPath.hashCode;

  @override
  String toString() {
    return 'Artist{id: $id, name: $name, artworkPath: $artworkPath}';
  }
}
