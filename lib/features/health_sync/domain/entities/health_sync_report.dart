/// What the latest sync with the platform health store brought in.
class HealthSyncReport {
  const HealthSyncReport({
    required this.syncedAt,
    required this.activityDays,
    required this.bodyEntries,
    required this.workouts,
    required this.sources,
  });

  final DateTime syncedAt;

  /// Days of steps, distance and active energy refreshed.
  final int activityDays;

  /// Weight / body-fat entries written to Body metrics.
  final int bodyEntries;

  /// Runs, walks and rides imported from watches and other apps.
  final int workouts;

  /// Apps and devices that supplied data, e.g. "Samsung Health".
  final List<String> sources;
}
