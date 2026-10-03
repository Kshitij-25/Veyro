/// Sleep stage as reported by the health store. [asleep] means the device
/// recorded sleep without splitting it into stages.
enum HealthSleepStage { awake, rem, light, deep, asleep }

class HealthSleepSegment {
  const HealthSleepSegment({
    required this.stage,
    required this.start,
    required this.end,
  });

  final HealthSleepStage stage;
  final DateTime start;
  final DateTime end;
}

/// One night of sleep, identified by the day it ended on.
class HealthSleepNight {
  const HealthSleepNight({
    required this.date,
    required this.segments,
    this.inBedStart,
    this.inBedEnd,
    this.sleepingHr,
  });

  final DateTime date;

  /// Non-overlapping, sorted by start.
  final List<HealthSleepSegment> segments;
  final DateTime? inBedStart;
  final DateTime? inBedEnd;

  /// Average heart rate between falling asleep and waking.
  final double? sleepingHr;
}
