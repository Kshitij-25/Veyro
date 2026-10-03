import 'package:fitness_trakcer/features/dashboard/domain/entities/coach_advice.dart';
import 'package:fitness_trakcer/features/recovery/domain/entities/recovery_snapshot.dart';
import 'package:fitness_trakcer/features/routines/domain/entities/routine.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/muscle_group.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout.dart';

/// Builds [CoachAdvice] from readiness, today's plan and recent training.
/// Plain rules, no network: readiness sets the tone, the plan and recently
/// trained muscles decide what to suggest.
abstract final class CoachAdvisor {
  static const _trackable = [
    MuscleGroup.chest,
    MuscleGroup.back,
    MuscleGroup.shoulders,
    MuscleGroup.legs,
    MuscleGroup.biceps,
    MuscleGroup.triceps,
    MuscleGroup.core,
  ];

  /// [workouts] are completed workouts from roughly the last two weeks.
  static CoachAdvice advise({
    required Readiness? readiness,
    required List<Routine> todaysRoutines,
    required List<Workout> workouts,
    required DateTime now,
  }) {
    final parts = <String>[];
    final score = readiness?.score;
    if (score != null) {
      parts.add(
        score >= 80
            ? 'Readiness is $score, so you are primed to train.'
            : score >= 60
            ? 'Readiness is $score, a normal session is fine.'
            : score >= 40
            ? 'Readiness is $score, so keep today moderate.'
            : 'Readiness is $score, so rest or keep it very light.',
      );
    }

    final lastTrained = <MuscleGroup, DateTime>{};
    for (final w in workouts) {
      for (final e in w.exercises) {
        if (e.sets.isEmpty) continue;
        final g = e.exercise.muscleGroup;
        final prev = lastTrained[g];
        if (prev == null || w.startedAt.isAfter(prev)) {
          lastTrained[g] = w.startedAt;
        }
      }
    }
    final recent = {
      for (final e in lastTrained.entries)
        if (now.difference(e.value).inHours < 48) e.key,
    };

    final routine = todaysRoutines.firstOrNull;
    if (routine != null) {
      final planned = {
        for (final r in routine.exercises) r.exercise.muscleGroup,
      }..removeAll({MuscleGroup.fullBody, MuscleGroup.cardio});
      final overlap = planned.intersection(recent);
      if (score != null && score < 40) {
        parts.add(
          '${routine.name} is planned; consider a lighter version or rest.',
        );
      } else if (overlap.isNotEmpty) {
        parts.add(
          '${routine.name} is planned. ${_list(overlap)} ${overlap.length == 1 ? 'was' : 'were'} trained in the last two days, so go lighter there.',
        );
      } else if (workouts.isNotEmpty) {
        parts.add(
          '${routine.name} is planned and its muscles have had time to recover.',
        );
      } else {
        parts.add('${routine.name} is planned for today.');
      }
    } else if (workouts.isEmpty) {
      parts.add('Start a workout to get suggestions based on what you train.');
    } else {
      final trainedYesterday = workouts.any(
        (w) =>
            DateTime(w.startedAt.year, w.startedAt.month, w.startedAt.day) ==
            DateTime(now.year, now.month, now.day - 1),
      );
      if (trainedYesterday && (score ?? 100) < 70) {
        parts.add('You trained yesterday, so an easy day or rest suits you.');
      } else {
        MuscleGroup? stalest;
        int? stalestDays;
        for (final g in _trackable) {
          final last = lastTrained[g];
          final days = last == null ? 99 : now.difference(last).inDays;
          if (stalestDays == null || days > stalestDays) {
            stalest = g;
            stalestDays = days;
          }
        }
        if (stalest != null && stalestDays != null && stalestDays >= 3) {
          parts.add(
            stalestDays >= 99
                ? 'You have not trained ${stalest.label.toLowerCase()} recently.'
                : 'You have not trained ${stalest.label.toLowerCase()} in $stalestDays days.',
          );
        } else {
          parts.add(
            'Nothing is planned today. Pick a routine or start an empty workout.',
          );
        }
      }
    }
    return CoachAdvice(text: parts.join(' '), routine: routine);
  }

  static String _list(Set<MuscleGroup> groups) {
    final names = [for (final g in groups) g.label.toLowerCase()];
    final text = names.length <= 1
        ? names.join()
        : '${names.sublist(0, names.length - 1).join(', ')} and ${names.last}';
    return text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
  }
}
