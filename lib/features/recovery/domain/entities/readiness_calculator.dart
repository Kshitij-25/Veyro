import 'package:fitness_trakcer/features/recovery/domain/entities/recovery_snapshot.dart';

/// Turns a [RecoverySnapshot] into a [Readiness] score.
///
/// Sleep counts for 40%, HRV against your own 2-week average for 35% and
/// resting heart rate against its average for 25%. Missing inputs are
/// skipped and the remaining weights are rescaled. With no inputs at all
/// there is no score.
abstract final class ReadinessCalculator {
  static Readiness? compute(
    RecoverySnapshot snapshot, {
    int sleepGoalMinutes = 480,
  }) {
    final parts = <(double score, double weight)>[];
    final notes = <String>[];

    final sleep = snapshot.lastSleepMinutes;
    if (sleep != null) {
      parts.add(((sleep / sleepGoalMinutes).clamp(0.0, 1.0) * 100, .40));
      notes.add('Sleep ${_hm(sleep)}');
    }

    final hrv = snapshot.latestHrv;
    final hrvBase = snapshot.hrvBaseline;
    if (hrv != null && hrvBase != null && hrvBase > 0) {
      final ratio = hrv / hrvBase - 1;
      parts.add(((50 + ratio * 250).clamp(0.0, 100.0), .35));
      notes.add('HRV ${_pct(ratio)} vs average');
    }

    final rhr = snapshot.latestRestingHr;
    final rhrBase = snapshot.restingHrBaseline;
    if (rhr != null && rhrBase != null && rhrBase > 0) {
      final ratio = rhr / rhrBase - 1;
      parts.add(((50 - ratio * 500).clamp(0.0, 100.0), .25));
      notes.add('Resting HR ${_pct(ratio)} vs average');
    }

    if (parts.isEmpty) return null;
    final totalWeight = parts.fold(0.0, (a, p) => a + p.$2);
    final score = (parts.fold(0.0, (a, p) => a + p.$1 * p.$2) / totalWeight)
        .round();
    final label = switch (score) {
      >= 80 => 'Primed to train',
      >= 60 => 'Ready',
      >= 40 => 'Take it easy',
      _ => 'Rest up',
    };
    return Readiness(score: score, label: label, summary: notes.join(' · '));
  }

  static String _hm(int minutes) => '${minutes ~/ 60}h ${minutes % 60}m';

  static String _pct(double ratio) {
    final p = (ratio * 100).round();
    if (p == 0) return 'on par';
    return p > 0 ? '+$p%' : '−${p.abs()}%';
  }
}
