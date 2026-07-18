import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:audiotags/audiotags.dart' as tags;
import 'package:flutter/foundation.dart';
import '../../domain/entities/scan_progress.dart';
import '../models/parsed_metadata.dart';

class DbFileMetadata {
  const DbFileMetadata({
    required this.fileSize,
    required this.dateModifiedMs,
  });

  final int fileSize;
  final int dateModifiedMs;

  Map<String, dynamic> toMap() {
    return {
      'fileSize': fileSize,
      'dateModifiedMs': dateModifiedMs,
    };
  }

  factory DbFileMetadata.fromMap(Map<dynamic, dynamic> map) {
    return DbFileMetadata(
      fileSize: map['fileSize'] as int,
      dateModifiedMs: map['dateModifiedMs'] as int,
    );
  }
}

class ScannerPipelineParams {
  const ScannerPipelineParams({
    required this.directories,
    required this.existingDbFiles,
    required this.sendPort,
  });

  final List<String> directories;
  final Map<String, DbFileMetadata> existingDbFiles;
  final SendPort sendPort;
}

class ScannerPipeline {
  ScannerPipeline();

  static const _supportedExtensions = {'.mp3', '.m4a', '.wav', '.flac', '.ogg'};

  /// Starts the scanning pipeline.
  /// Emits progress events and returns parsed metadata chunks.
  Stream<ScanProgress> scan({
    required List<String> directories,
    required Map<String, DbFileMetadata> existingDbFiles,
    required Future<void> Function(List<ParsedMetadata> chunk) onChunkParsed,
    required Future<void> Function(List<String> deletedPaths) onFilesDeleted,
  }) {
    final controller = StreamController<ScanProgress>();
    final receivePort = ReceivePort();

    // Spawn background isolate
    Isolate.spawn(
      _isolateEntryPoint,
      ScannerPipelineParams(
        directories: directories,
        existingDbFiles: existingDbFiles,
        sendPort: receivePort.sendPort,
      ),
    ).then((isolate) {
      receivePort.listen(
        (message) async {
          if (message is Map) {
            final type = message['type'] as String;
            switch (type) {
              case 'progress':
                final stageStr = message['stage'] as String;
                final stage = ScanStage.values.firstWhere(
                  (e) => e.name == stageStr,
                  orElse: () => ScanStage.idle,
                );
                controller.add(
                  ScanProgress(
                    stage: stage,
                    scannedCount: message['scannedCount'] as int,
                    totalCount: message['totalCount'] as int,
                    currentFilePath: message['filePath'] as String,
                  ),
                );
                break;
              case 'chunk':
                final list = message['list'] as List;
                final chunk = list
                    .map((item) => ParsedMetadata.fromMap(Map<String, dynamic>.from(item as Map)))
                    .toList();
                await onChunkParsed(chunk);
                break;
              case 'deleted':
                final list = List<String>.from(message['paths'] as List);
                await onFilesDeleted(list);
                break;
              case 'done':
                controller.add(ScanProgress.complete());
                receivePort.close();
                isolate.kill();
                await controller.close();
                break;
              case 'error':
                final error = message['message'] as String;
                controller.add(
                  ScanProgress(
                    stage: ScanStage.failed,
                    scannedCount: 0,
                    totalCount: 0,
                    currentFilePath: error,
                  ),
                );
                receivePort.close();
                isolate.kill();
                await controller.close();
                break;
            }
          }
        },
        onError: (Object err) {
          controller.add(
            ScanProgress(
              stage: ScanStage.failed,
              scannedCount: 0,
              totalCount: 0,
              currentFilePath: err.toString(),
            ),
          );
          receivePort.close();
          isolate.kill();
          controller.close();
        },
      );
    }).catchError((Object err) {
      controller.add(
        ScanProgress(
          stage: ScanStage.failed,
          scannedCount: 0,
          totalCount: 0,
          currentFilePath: err.toString(),
        ),
      );
      controller.close();
    });

    return controller.stream;
  }

  /// Top-level static isolate entry point.
  static void _isolateEntryPoint(ScannerPipelineParams params) async {
    final sendPort = params.sendPort;
    final directories = params.directories;
    final existingDbFiles = params.existingDbFiles;

    try {
      sendPort.send({
        'type': 'progress',
        'stage': ScanStage.discovering.name,
        'scannedCount': 0,
        'totalCount': 0,
        'filePath': '',
      });

      // 1. Discover all files
      final allFiles = <File>[];
      for (final dirPath in directories) {
        final dir = Directory(dirPath);
        if (!await dir.exists()) continue;

        try {
          final fileList = await dir.list(recursive: true).toList();
          for (final entity in fileList) {
            if (entity is File) {
              final ext = pExtension(entity.path).toLowerCase();
              if (_supportedExtensions.contains(ext)) {
                allFiles.add(entity);
              }
            }
          }
        } catch (e) {
          debugPrint('Isolate dir list error: $e');
        }
      }

      sendPort.send({
        'type': 'progress',
        'stage': ScanStage.discovering.name,
        'scannedCount': allFiles.length,
        'totalCount': allFiles.length,
        'filePath': '',
      });

      // 2. Incremental sync comparison
      final discoveredPathsSet = allFiles.map((f) => f.path).toSet();
      final deletedPaths = <String>[];

      for (final dbPath in existingDbFiles.keys) {
        if (!discoveredPathsSet.contains(dbPath)) {
          deletedPaths.add(dbPath);
        }
      }

      if (deletedPaths.isNotEmpty) {
        sendPort.send({
          'type': 'deleted',
          'paths': deletedPaths,
        });
      }

      final filesToParse = <File>[];
      for (final file in allFiles) {
        final path = file.path;
        final dbFile = existingDbFiles[path];

        if (dbFile == null) {
          filesToParse.add(file);
        } else {
          // Compare size & modification date
          try {
            final stat = await file.stat();
            if (stat.size != dbFile.fileSize ||
                stat.modified.millisecondsSinceEpoch != dbFile.dateModifiedMs) {
              filesToParse.add(file);
            }
          } catch (e) {
            // If stat fails, play it safe and parse
            filesToParse.add(file);
          }
        }
      }

      if (filesToParse.isEmpty) {
        sendPort.send({'type': 'done'});
        return;
      }

      sendPort.send({
        'type': 'progress',
        'stage': ScanStage.extracting.name,
        'scannedCount': 0,
        'totalCount': filesToParse.length,
        'filePath': '',
      });

      // 3. Parse files in chunks
      var parsedCount = 0;
      final currentChunk = <Map<String, dynamic>>[];
      const chunkSize = 100; // Chunk size of 100 to yield frequently and report progress

      for (final file in filesToParse) {
        try {
          final stat = await file.stat();
          ParsedMetadata? parsed;

          // Attempt to parse tags
          try {
            final tag = await tags.AudioTags.read(file.path);
            if (tag != null) {
              Uint8List? artworkBytes;
              String? artworkMimeType;

              if (tag.pictures.isNotEmpty) {
                final pic = tag.pictures.first;
                artworkBytes = pic.bytes;
                artworkMimeType = _mimeTypeToString(pic.mimeType);
              }

              parsed = ParsedMetadata(
                filePath: file.path,
                fileSize: stat.size,
                dateModified: stat.modified,
                title: tag.title,
                artist: tag.artist,
                album: tag.album,
                genre: tag.genre,
                year: tag.year,
                durationMs: tag.duration,
                artworkBytes: artworkBytes,
                artworkMimeType: artworkMimeType,
              );
            }
          } catch (e) {
            debugPrint('Tag reading failed inside isolate for ${file.path}: $e');
          }

          // Fallback if tag parsing fails or is empty
          parsed ??= ParsedMetadata(
            filePath: file.path,
            fileSize: stat.size,
            dateModified: stat.modified,
            title: pBasenameWithoutExtension(file.path),
            durationMs: 0,
          );

          currentChunk.add(parsed.toMap());
        } catch (e) {
          debugPrint('Error parsing file stat: $e');
        }

        parsedCount++;
        if (parsedCount % 10 == 0 || parsedCount == filesToParse.length) {
          sendPort.send({
            'type': 'progress',
            'stage': ScanStage.extracting.name,
            'scannedCount': parsedCount,
            'totalCount': filesToParse.length,
            'filePath': file.path,
          });
        }

        if (currentChunk.length >= chunkSize) {
          sendPort.send({
            'type': 'chunk',
            'list': List<Map<String, dynamic>>.from(currentChunk),
          });
          currentChunk.clear();
        }
      }

      if (currentChunk.isNotEmpty) {
        sendPort.send({
          'type': 'chunk',
          'list': currentChunk,
        });
      }

      sendPort.send({'type': 'done'});
    } catch (e) {
      sendPort.send({
        'type': 'error',
        'message': e.toString(),
      });
    }
  }

  static String _mimeTypeToString(tags.MimeType mimeType) {
    switch (mimeType) {
      case tags.MimeType.png:
        return 'image/png';
      case tags.MimeType.jpeg:
        return 'image/jpeg';
      case tags.MimeType.tiff:
        return 'image/tiff';
      case tags.MimeType.bmp:
        return 'image/bmp';
      case tags.MimeType.gif:
        return 'image/gif';
      case tags.MimeType.none:
        return 'image/jpeg';
    }
  }

  // Mini helpers that replicate path package to avoid importing path directly on Isolate if it causes issues.
  static String pExtension(String path) {
    final idx = path.lastIndexOf('.');
    return idx == -1 ? '' : path.substring(idx);
  }

  static String pBasenameWithoutExtension(String path) {
    final normalized = path.replaceAll('\\', '/');
    final startIdx = normalized.lastIndexOf('/') + 1;
    final endIdx = normalized.lastIndexOf('.');
    if (endIdx <= startIdx) {
      return normalized.substring(startIdx);
    }
    return normalized.substring(startIdx, endIdx);
  }
}
