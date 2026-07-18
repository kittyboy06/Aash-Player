class Song {
  const Song({
    required this.id,
    required this.title,
    this.albumId,
    this.artistId,
    required this.filePath,
    required this.duration,
    this.trackNumber,
    this.discNumber,
    this.genre,
    this.year,
    this.bitrate,
    this.sampleRate,
    this.artworkPath,
    required this.playCount,
    this.lastPlayed,
    required this.dateAdded,
  });

  final String id;
  final String title;
  final String? albumId;
  final String? artistId;
  final String filePath;
  final Duration duration;
  final int? trackNumber;
  final int? discNumber;
  final String? genre;
  final int? year;
  final int? bitrate;
  final int? sampleRate;
  final String? artworkPath;
  final int playCount;
  final DateTime? lastPlayed;
  final DateTime dateAdded;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Song &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          albumId == other.albumId &&
          artistId == other.artistId &&
          filePath == other.filePath &&
          duration == other.duration &&
          trackNumber == other.trackNumber &&
          discNumber == other.discNumber &&
          genre == other.genre &&
          year == other.year &&
          bitrate == other.bitrate &&
          sampleRate == other.sampleRate &&
          artworkPath == other.artworkPath &&
          playCount == other.playCount &&
          lastPlayed == other.lastPlayed &&
          dateAdded == other.dateAdded;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      albumId.hashCode ^
      artistId.hashCode ^
      filePath.hashCode ^
      duration.hashCode ^
      trackNumber.hashCode ^
      discNumber.hashCode ^
      genre.hashCode ^
      year.hashCode ^
      bitrate.hashCode ^
      sampleRate.hashCode ^
      artworkPath.hashCode ^
      playCount.hashCode ^
      lastPlayed.hashCode ^
      dateAdded.hashCode;

  @override
  String toString() {
    return 'Song{id: $id, title: $title, albumId: $albumId, artistId: $artistId, filePath: $filePath, duration: $duration, trackNumber: $trackNumber, discNumber: $discNumber, genre: $genre, year: $year, bitrate: $bitrate, sampleRate: $sampleRate, artworkPath: $artworkPath, playCount: $playCount, lastPlayed: $lastPlayed, dateAdded: $dateAdded}';
  }
}
