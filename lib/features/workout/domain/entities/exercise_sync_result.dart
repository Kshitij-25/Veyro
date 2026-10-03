/// Outcome of importing the remote exercise catalogue.
class ExerciseSyncResult {
  const ExerciseSyncResult({
    required this.added,
    required this.updated,
    required this.skipped,
    this.wasUpToDate = false,
  });

  /// Nothing was fetched because the last sync is recent.
  const ExerciseSyncResult.upToDate()
    : added = 0,
      updated = 0,
      skipped = 0,
      wasUpToDate = true;

  final int added;
  final int updated;

  /// Remote exercises ignored (duplicates of existing names, no English name).
  final int skipped;
  final bool wasUpToDate;
}
