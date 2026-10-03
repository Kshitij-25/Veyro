import 'package:equatable/equatable.dart';

/// Sleep, HRV and resting heart rate for one day. Values are `null` when the
/// health store has nothing for that day.
class RecoveryDay extends Equatable {
  const RecoveryDay({
    required this.date,
    this.hrvMs,
    this.restingHr,
    this.sleepMinutes,
  });

  final DateTime date;
  final double? hrvMs;
  final double? restingHr;

  /// Time asleep in the night that ended on [date].
  final int? sleepMinutes;

  bool get hasData =>
      hrvMs != null || restingHr != null || sleepMinutes != null;

  @override
  List<Object?> get props => [date, hrvMs, restingHr, sleepMinutes];
}

/// The last two weeks of recovery readings, oldest first; the last entry is
/// today.
class RecoverySnapshot extends Equatable {
  const RecoverySnapshot(this.days);

  final List<RecoveryDay> days;

  bool get hasData => days.any((d) => d.hasData);

  /// Last night's sleep, if recorded.
  int? get lastSleepMinutes => days.isEmpty ? null : days.last.sleepMinutes;

  /// Most recent HRV from today or yesterday.
  double? get latestHrv => _recent((d) => d.hrvMs);

  /// Most recent resting heart rate from today or yesterday.
  double? get latestRestingHr => _recent((d) => d.restingHr);

  double? get hrvBaseline => _baseline((d) => d.hrvMs);
  double? get restingHrBaseline => _baseline((d) => d.restingHr);

  double? _recent(double? Function(RecoveryDay) pick) {
    for (final d in days.reversed.take(2)) {
      final v = pick(d);
      if (v != null) return v;
    }
    return null;
  }

  /// Average over the days before today; needs at least three readings.
  double? _baseline(double? Function(RecoveryDay) pick) {
    final values = [
      for (final d in days.take(days.length - 1))
        if (pick(d) != null) pick(d)!,
    ];
    if (values.length < 3) return null;
    return values.reduce((a, b) => a + b) / values.length;
  }

  @override
  List<Object?> get props => [days];
}

/// A 0–100 readiness score with a short explanation.
class Readiness extends Equatable {
  const Readiness({
    required this.score,
    required this.label,
    required this.summary,
  });

  final int score;
  final String label;
  final String summary;

  @override
  List<Object?> get props => [score, label, summary];
}
