/// One day's sleep (the night that ended on it), HRV and resting heart rate,
/// read in bulk for the history import. Any value can be `null`.
class HealthRecoveryRecord {
  const HealthRecoveryRecord({
    required this.date,
    this.asleepMinutes,
    this.awakeMinutes,
    this.remMinutes,
    this.lightMinutes,
    this.deepMinutes,
    this.bedtime,
    this.wakeTime,
    this.hrvMs,
    this.restingHr,
  });

  final DateTime date;
  final int? asleepMinutes;
  final int? awakeMinutes;
  final int? remMinutes;
  final int? lightMinutes;
  final int? deepMinutes;
  final DateTime? bedtime;
  final DateTime? wakeTime;
  final double? hrvMs;
  final double? restingHr;

  bool get hasData =>
      asleepMinutes != null || hrvMs != null || restingHr != null;
}
