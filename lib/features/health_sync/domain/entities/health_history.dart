/// Running totals while the whole Health history is being imported.
class HealthHistoryProgress {
  const HealthHistoryProgress({
    required this.month,
    this.activityDays = 0,
    this.workouts = 0,
    this.bodyEntries = 0,
    this.recoveryDays = 0,
  });

  /// The month being read right now (importing goes newest to oldest).
  final DateTime month;
  final int activityDays;
  final int workouts;
  final int bodyEntries;
  final int recoveryDays;

  int get total => activityDays + workouts + bodyEntries + recoveryDays;
}

class HealthHistoryReport {
  const HealthHistoryReport({
    required this.progress,
    required this.oldest,
    required this.completed,
  });

  final HealthHistoryProgress progress;

  /// The earliest month that had any data, if any did.
  final DateTime? oldest;

  /// False when the user cancelled part-way.
  final bool completed;
}
