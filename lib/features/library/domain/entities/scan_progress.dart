enum ScanStage {
  idle,
  discovering,
  extracting,
  saving,
  complete,
  failed,
}

class ScanProgress {
  const ScanProgress({
    required this.stage,
    required this.scannedCount,
    required this.totalCount,
    required this.currentFilePath,
  });

  factory ScanProgress.initial() => const ScanProgress(
        stage: ScanStage.idle,
        scannedCount: 0,
        totalCount: 0,
        currentFilePath: '',
      );

  factory ScanProgress.complete() => const ScanProgress(
        stage: ScanStage.complete,
        scannedCount: 0,
        totalCount: 0,
        currentFilePath: '',
      );

  final ScanStage stage;
  final int scannedCount;
  final int totalCount;
  final String currentFilePath;

  bool get isComplete => stage == ScanStage.complete;
  double get percentage => totalCount > 0 ? (scannedCount / totalCount) : 0.0;

  @override
  String toString() {
    return 'ScanProgress{stage: $stage, scannedCount: $scannedCount, totalCount: $totalCount, currentFilePath: $currentFilePath}';
  }
}
