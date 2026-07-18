class Lyrics {
  const Lyrics({
    required this.songId,
    required this.lyricsText,
    this.syncedLyrics,
  });

  final String songId;
  final String lyricsText;
  final String? syncedLyrics;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Lyrics &&
          runtimeType == other.runtimeType &&
          songId == other.songId &&
          lyricsText == other.lyricsText &&
          syncedLyrics == other.syncedLyrics;

  @override
  int get hashCode =>
      songId.hashCode ^ lyricsText.hashCode ^ syncedLyrics.hashCode;

  @override
  String toString() {
    return 'Lyrics{songId: $songId, lyricsTextLength: ${lyricsText.length}, hasSynced: ${syncedLyrics != null}}';
  }
}
