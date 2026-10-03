import 'package:fitness_trakcer/core/extensions/date_time_extensions.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/clock.dart';
import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/activity/domain/repositories/activity_repository.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/repositories/tracked_activity_repository.dart';
import 'package:fitness_trakcer/features/report/domain/entities/weekly_report.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout.dart';
import 'package:fitness_trakcer/features/workout/domain/repositories/workout_repository.dart';
import 'package:injectable/injectable.dart';

/// Builds the report for the last seven days from workouts, recorded
/// activities and daily activity (steps and distance).
@lazySingleton
class GetWeeklyReport implements UseCase<WeeklyReport, NoParams> {
  const GetWeeklyReport(
    this._workouts,
    this._tracked,
    this._activity,
    this._clock,
  );

  final WorkoutRepository _workouts;
  final TrackedActivityRepository _tracked;
  final ActivityRepository _activity;
  final Clock _clock;

  @override
  Future<Result<WeeklyReport>> call(NoParams params) => guard(() async {
    final now = _clock.now();
    final thisWeek = DateRange.lastDays(7, until: now);
    final lastWeek = DateRange.lastDays(
      14,
      until: now.subtract(const Duration(days: 7)),
    );
    final both = DateRange(lastWeek.start, thisWeek.end);

    final workouts = (await _workouts.getCompletedWorkouts(both)).getOrThrow();
    final tracked = (await _tracked.getActivities(both)).getOrThrow();
    final days = (await _activity.getRange(both)).getOrThrow();

    final cur = _Totals();
    final prev = _Totals();
    final minutesPerDay = List.filled(7, 0);

    for (final w in workouts) {
      final isCur = thisWeek.contains(w.startedAt);
      final t = isCur ? cur : prev;
      final minutes = w.durationAt(now).inMinutes;
      t.workouts++;
      t.minutes += minutes;
      t.volumeKg += w.totalVolumeKg;
      t.kcal += w.caloriesBurned ?? 0;
      if (isCur) {
        final i = w.startedAt.startOfDay.difference(thisWeek.start).inDays;
        if (i >= 0 && i < 7) minutesPerDay[i] += minutes;
      }
    }
    for (final a in tracked) {
      final isCur = thisWeek.contains(a.startedAt);
      final t = isCur ? cur : prev;
      final minutes = a.movingDuration.inMinutes;
      t.minutes += minutes;
      t.kcal += a.caloriesKcal;
      t.trackedKm += a.distanceMeters / 1000;
      if (isCur) {
        final i = a.startedAt.startOfDay.difference(thisWeek.start).inDays;
        if (i >= 0 && i < 7) minutesPerDay[i] += minutes;
      }
    }
    for (final d in days) {
      final t = thisWeek.contains(d.date) ? cur : prev;
      t.stepDays++;
      t.steps += d.steps;
      t.dailyKm += d.distanceMeters / 1000;
    }

    final heavy = _heaviestSet(
      workouts.where((w) => thisWeek.contains(w.startedAt)),
    );
    final longest = tracked
        .where((a) => thisWeek.contains(a.startedAt))
        .fold<double>(0, (m, a) => a.distanceMeters > m ? a.distanceMeters : m);
    final busiest = minutesPerDay.indexed.fold<(int, int)>((
      0,
      0,
    ), (m, e) => e.$2 > m.$2 ? (e.$1, e.$2) : m);

    final avgSteps = cur.stepDays == 0 ? 0 : cur.steps ~/ cur.stepDays;
    final prevAvgSteps = prev.stepDays == 0 ? 0 : prev.steps ~/ prev.stepDays;
    final distance = cur.dailyKm > cur.trackedKm ? cur.dailyKm : cur.trackedKm;
    final prevDistance = prev.dailyKm > prev.trackedKm
        ? prev.dailyKm
        : prev.trackedKm;

    final insights = <String>[];
    final dw = cur.workouts - prev.workouts;
    if (cur.workouts == 0) {
      insights.add('No workouts logged in the last 7 days.');
    } else if (prev.workouts == 0) {
      insights.add(
        'You trained ${cur.workouts} ${cur.workouts == 1 ? 'day' : 'days'} this week.',
      );
    } else if (dw == 0) {
      insights.add(
        'You trained ${cur.workouts} days, the same as the week before.',
      );
    } else {
      insights.add(
        'You trained ${cur.workouts} days, ${dw.abs()} ${dw > 0 ? 'more' : 'fewer'} than the week before.',
      );
    }
    if (prev.volumeKg > 0 && cur.volumeKg > 0) {
      final pct = ((cur.volumeKg / prev.volumeKg - 1) * 100).round();
      insights.add(
        pct == 0
            ? 'Lifting volume is flat on last week.'
            : 'Lifting volume is ${pct > 0 ? 'up' : 'down'} ${pct.abs()}% on last week.',
      );
    }
    if (avgSteps > 0 && prevAvgSteps > 0) {
      final pct = ((avgSteps / prevAvgSteps - 1) * 100).round();
      if (pct != 0) {
        insights.add(
          'Daily steps are ${pct > 0 ? 'up' : 'down'} ${pct.abs()}% on last week.',
        );
      }
    }
    final restDays = minutesPerDay.where((m) => m == 0).length;
    if (cur.workouts > 0) {
      insights.add('$restDays of the last 7 days had no recorded training.');
    }

    return WeeklyReport(
      start: thisWeek.start,
      end: now.startOfDay,
      workouts: cur.workouts,
      prevWorkouts: prev.workouts,
      activeMinutes: cur.minutes,
      prevActiveMinutes: prev.minutes,
      minutesPerDay: minutesPerDay,
      volumeKg: cur.volumeKg,
      prevVolumeKg: prev.volumeKg,
      caloriesBurned: cur.kcal.round(),
      prevCaloriesBurned: prev.kcal.round(),
      avgSteps: avgSteps,
      prevAvgSteps: prevAvgSteps,
      distanceKm: distance,
      prevDistanceKm: prevDistance,
      heaviest: heavy,
      longestActivityKm: longest / 1000,
      busiestDay: busiest.$2 > 0
          ? thisWeek.start.add(Duration(days: busiest.$1))
          : null,
      busiestMinutes: busiest.$2,
      insights: insights,
    );
  });

  HeaviestSet? _heaviestSet(Iterable<Workout> workouts) {
    HeaviestSet? best;
    for (final w in workouts) {
      for (final e in w.exercises) {
        for (final s in e.sets) {
          final kg = s.weightKg;
          if (s.isCompleted && kg != null && kg > (best?.weightKg ?? 0)) {
            best = HeaviestSet(e.exercise.name, kg, s.reps ?? 0);
          }
        }
      }
    }
    return best;
  }
}

class _Totals {
  int workouts = 0;
  int minutes = 0;
  double volumeKg = 0;
  double kcal = 0;
  double trackedKm = 0;
  double dailyKm = 0;
  int steps = 0;
  int stepDays = 0;
}
