class ScanProgress {
  const ScanProgress({
    required this.scannedCount,
    required this.totalCount,
    required this.currentFilePath,
    required this.isComplete,
  });

  final int scannedCount;
  final int totalCount;
  final String currentFilePath;
  final bool isComplete;

  double get percentage => totalCount > 0 ? (scannedCount / totalCount) : 0.0;
}
