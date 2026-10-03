import 'package:equatable/equatable.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/muscle_group.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout.dart';

class MuscleRecovery extends Equatable {
  const MuscleRecovery({
    required this.group,
    required this.percent,
    this.lastTrained,
    this.sets = 0,
  });

  final MuscleGroup group;

  /// 0-100, how recovered the muscle is. 100 when not trained recently.
  final int percent;
  final DateTime? lastTrained;

  /// Working sets in the last three days that drove the estimate.
  final int sets;

  String get status => percent >= 80
      ? 'Ready'
      : percent >= 55
      ? 'Recovering'
      : 'Fatigued';

  @override
  List<Object?> get props => [group, percent, lastTrained, sets];
}

/// Estimates muscle recovery from logged workouts. A rule of thumb, not a
/// measurement: the more working sets in the last three days, the longer a
/// muscle needs (36 h for a light session up to 84 h for a heavy one, plus
/// 12 h for legs and glutes), counted from when it was last trained.
abstract final class MuscleRecoveryCalculator {
  static const tracked = [
    MuscleGroup.chest,
    MuscleGroup.back,
    MuscleGroup.shoulders,
    MuscleGroup.biceps,
    MuscleGroup.triceps,
    MuscleGroup.legs,
    MuscleGroup.glutes,
    MuscleGroup.core,
  ];

  static List<MuscleRecovery> compute(List<Workout> workouts, DateTime now) {
    return [for (final group in tracked) _forGroup(group, workouts, now)];
  }

  static MuscleRecovery _forGroup(
    MuscleGroup group,
    List<Workout> workouts,
    DateTime now,
  ) {
    DateTime? last;
    var sets = 0;
    for (final w in workouts) {
      final working = w.exercises
          .where((e) => e.exercise.muscleGroup == group)
          .fold<int>(
            0,
            (n, e) =>
                n + e.sets.where((s) => s.isCompleted && !s.isWarmup).length,
          );
      if (working == 0) continue;
      final at = w.endedAt ?? w.startedAt;
      if (last == null || at.isAfter(last)) last = at;
      if (now.difference(at).inHours < 72) sets += working;
    }
    if (last == null) return MuscleRecovery(group: group, percent: 100);
    final needed =
        36 +
        4 * sets.clamp(0, 12) +
        (group == MuscleGroup.legs || group == MuscleGroup.glutes ? 12 : 0);
    final hours = now.difference(last).inMinutes / 60;
    return MuscleRecovery(
      group: group,
      percent: (hours / needed * 100).clamp(0, 100).round(),
      lastTrained: last,
      sets: sets,
    );
  }
}
