/// Recovery-related readings from the platform health store for one day.
/// Any value can be `null` when nothing was recorded.
class HealthRecoveryDay {
  const HealthRecoveryDay({
    required this.date,
    this.hrvMs,
    this.restingHr,
    this.sleepMinutes,
  });

  final DateTime date;

  /// Average heart-rate variability that day (SDNN on iOS, RMSSD on Android).
  final double? hrvMs;
  final double? restingHr;

  /// Time asleep in the night that ended on [date].
  final int? sleepMinutes;
}
