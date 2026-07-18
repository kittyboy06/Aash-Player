import 'dart:typed_data';

class ParsedMetadata {
  const ParsedMetadata({
    required this.filePath,
    required this.fileSize,
    required this.dateModified,
    this.title,
    this.artist,
    this.album,
    this.albumArtist,
    this.genre,
    this.year,
    this.trackNumber,
    this.discNumber,
    this.durationMs,
    this.artworkBytes,
    this.artworkMimeType,
  });

  final String filePath;
  final int fileSize;
  final DateTime dateModified;
  final String? title;
  final String? artist;
  final String? album;
  final String? albumArtist;
  final String? genre;
  final int? year;
  final int? trackNumber;
  final int? discNumber;
  final int? durationMs;
  final Uint8List? artworkBytes;
  final String? artworkMimeType;

  Map<String, dynamic> toMap() {
    return {
      'filePath': filePath,
      'fileSize': fileSize,
      'dateModified': dateModified.millisecondsSinceEpoch,
      'title': title,
      'artist': artist,
      'album': album,
      'albumArtist': albumArtist,
      'genre': genre,
      'year': year,
      'trackNumber': trackNumber,
      'discNumber': discNumber,
      'durationMs': durationMs,
      'artworkBytes': artworkBytes,
      'artworkMimeType': artworkMimeType,
    };
  }

  factory ParsedMetadata.fromMap(Map<String, dynamic> map) {
    return ParsedMetadata(
      filePath: map['filePath'] as String,
      fileSize: map['fileSize'] as int,
      dateModified: DateTime.fromMillisecondsSinceEpoch(map['dateModified'] as int),
      title: map['title'] as String?,
      artist: map['artist'] as String?,
      album: map['album'] as String?,
      albumArtist: map['albumArtist'] as String?,
      genre: map['genre'] as String?,
      year: map['year'] as int?,
      trackNumber: map['trackNumber'] as int?,
      discNumber: map['discNumber'] as int?,
      durationMs: map['durationMs'] as int?,
      artworkBytes: map['artworkBytes'] as Uint8List?,
      artworkMimeType: map['artworkMimeType'] as String?,
    );
  }
}
