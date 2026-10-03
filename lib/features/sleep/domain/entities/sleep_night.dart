import 'dart:math' as math;

import 'package:equatable/equatable.dart';

enum SleepStage { awake, rem, light, deep, asleep }

class SleepSegment extends Equatable {
  const SleepSegment(this.stage, this.start, this.end);

  final SleepStage stage;
  final DateTime start;
  final DateTime end;

  int get minutes => end.difference(start).inMinutes;

  @override
  List<Object?> get props => [stage, start, end];
}

/// One night of sleep, identified by the day it ended on.
class SleepNight extends Equatable {
  const SleepNight({
    required this.date,
    required this.segments,
    this.sleepingHr,
  });

  final DateTime date;
  final List<SleepSegment> segments;
  final double? sleepingHr;

  DateTime get bedtime => segments.first.start;
  DateTime get wakeTime => segments.last.end;
  int get spanMinutes => wakeTime.difference(bedtime).inMinutes;

  int _minutes(bool Function(SleepStage) test) =>
      segments.where((s) => test(s.stage)).fold(0, (sum, s) => sum + s.minutes);

  int get awakeMinutes => _minutes((s) => s == SleepStage.awake);
  int get remMinutes => _minutes((s) => s == SleepStage.rem);
  int get lightMinutes => _minutes((s) => s == SleepStage.light);
  int get deepMinutes => _minutes((s) => s == SleepStage.deep);
  int get asleepMinutes => _minutes((s) => s != SleepStage.awake);

  /// False when the device only reports "asleep" with no stage detail.
  bool get hasStages => segments.any(
    (s) =>
        s.stage == SleepStage.rem ||
        s.stage == SleepStage.light ||
        s.stage == SleepStage.deep,
  );

  /// Share of the time between bedtime and waking spent asleep.
  double get efficiency =>
      spanMinutes <= 0 ? 0 : (asleepMinutes / spanMinutes).clamp(0, 1);

  /// 0-100. Duration against the goal counts 60%, efficiency 25% and, when
  /// stages are known, the share spent in deep + REM sleep 15% (about 40% is
  /// a full mark). Without stages those 15 points follow duration.
  int score(int goalMinutes) {
    final duration = (asleepMinutes / math.max(goalMinutes, 1)).clamp(0.0, 1.0);
    final restorative = hasStages && asleepMinutes > 0
        ? ((deepMinutes + remMinutes) / asleepMinutes / 0.4).clamp(0.0, 1.0)
        : duration;
    return ((duration * 60) + (efficiency * 25) + (restorative * 15)).round();
  }

  @override
  List<Object?> get props => [date, segments, sleepingHr];
}

/// A night's total from the imported history (no stage detail needed).
class SleepDay extends Equatable {
  const SleepDay({required this.date, required this.asleepMinutes});

  final DateTime date;
  final int asleepMinutes;

  @override
  List<Object?> get props => [date, asleepMinutes];
}
