import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ArtworkCacheResult {
  const ArtworkCacheResult({
    required this.hash,
    required this.filePath,
  });

  final String hash;
  final String filePath;
}

class ArtworkCacheService {
  ArtworkCacheService({this.customBaseDir});

  final Directory? customBaseDir;
  Directory? _artworkDir;

  Future<Directory> _getArtworkDirectory() async {
    if (_artworkDir != null) return _artworkDir!;

    final baseDir = customBaseDir ?? await getApplicationSupportDirectory();
    final artworkPath = p.join(baseDir.path, 'artwork');
    final dir = Directory(artworkPath);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    _artworkDir = dir;
    return dir;
  }

  /// Caches raw image bytes using SHA-256 hash.
  /// Returns the computed hash and local file path.
  Future<ArtworkCacheResult?> cacheArtwork(Uint8List bytes, String? mimeType) async {
    if (bytes.isEmpty) return null;

    // 1. Compute SHA-256
    final hash = sha256.convert(bytes).toString();

    // 2. Get file extension from MIME type
    final ext = _getExtensionFromMimeType(mimeType);

    // 3. Resolve file path
    final dir = await _getArtworkDirectory();
    final filePath = p.join(dir.path, '$hash$ext');
    final file = File(filePath);

    // 4. Write if not already cached (deduplication)
    if (!await file.exists()) {
      await file.writeAsBytes(bytes);
    }

    return ArtworkCacheResult(
      hash: hash,
      filePath: filePath,
    );
  }

  String _getExtensionFromMimeType(String? mimeType) {
    if (mimeType == null) return '.jpg';
    switch (mimeType.toLowerCase()) {
      case 'image/png':
        return '.png';
      case 'image/gif':
        return '.gif';
      case 'image/webp':
        return '.webp';
      case 'image/bmp':
        return '.bmp';
      case 'image/jpeg':
      case 'image/jpg':
      default:
        return '.jpg';
    }
  }
}
