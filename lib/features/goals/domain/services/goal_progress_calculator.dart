import 'package:fitness_trakcer/core/extensions/date_time_extensions.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/clock.dart';
import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:fitness_trakcer/features/activity/domain/repositories/activity_repository.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/usecases/get_latest_weight.dart';
import 'package:fitness_trakcer/features/goals/domain/entities/goal.dart';
import 'package:fitness_trakcer/features/goals/domain/entities/goal_period.dart';
import 'package:fitness_trakcer/features/goals/domain/entities/goal_progress.dart';
import 'package:fitness_trakcer/features/goals/domain/entities/goal_type.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/repositories/tracked_activity_repository.dart';
import 'package:fitness_trakcer/features/workout/domain/repositories/workout_repository.dart';
import 'package:injectable/injectable.dart';

/// Measures goals against what the user has actually done, including streaks.
@lazySingleton
class GoalProgressCalculator {
  const GoalProgressCalculator(
    this._activity,
    this._workouts,
    this._trackedActivities,
    this._getLatestWeight,
    this._clock,
  );

  static const _dailyLookbackDays = 90;
  static const _weeklyLookbackWeeks = 26;

  final ActivityRepository _activity;
  final WorkoutRepository _workouts;
  final TrackedActivityRepository _trackedActivities;
  final GetLatestWeight _getLatestWeight;
  final Clock _clock;

  Future<GoalProgress> calculate(Goal goal) async {
    return switch (goal.type.period) {
      GoalPeriod.daily => _calculateDaily(goal),
      GoalPeriod.weekly => _calculateWeekly(goal),
      GoalPeriod.overall => _calculateWeight(goal),
    };
  }

  Future<GoalProgress> _calculateDaily(Goal goal) async {
    final today = _clock.now().startOfDay;
    final range = DateRange.lastDays(_dailyLookbackDays, until: today);
    final values = await _dailyValues(goal.type, range);

    final achieved = [
      for (final day in range.days)
        values[day.dayKey] != null &&
            goal.type.isMet(values[day.dayKey]!, goal.targetValue),
    ];
    final current = values[today.dayKey] ?? 0;
    return _build(goal, current, achieved);
  }

  Future<GoalProgress> _calculateWeekly(Goal goal) async {
    final thisWeek = _clock.now().startOfWeek;
    final firstWeek = DateTime(
      thisWeek.year,
      thisWeek.month,
      thisWeek.day - 7 * (_weeklyLookbackWeeks - 1),
    );
    final range = DateRange(
      firstWeek,
      DateTime(thisWeek.year, thisWeek.month, thisWeek.day + 7),
    );
    final values = await _weeklyValues(goal.type, range);

    final weekStarts = [
      for (var i = 0; i < _weeklyLookbackWeeks; i++)
        DateTime(firstWeek.year, firstWeek.month, firstWeek.day + 7 * i),
    ];
    final achieved = [
      for (final week in weekStarts)
        goal.type.isMet(values[week.dayKey] ?? 0, goal.targetValue),
    ];
    return _build(goal, values[thisWeek.dayKey] ?? 0, achieved);
  }

  Future<GoalProgress> _calculateWeight(Goal goal) async {
    final current =
        (await _getLatestWeight(const NoParams())).dataOrNull ??
        goal.startValue ??
        goal.targetValue;
    final start = goal.startValue ?? current;
    final target = goal.targetValue;

    final bool achieved;
    final double fraction;
    if (start == target) {
      achieved = current == target;
      fraction = achieved ? 1 : 0;
    } else {
      final losing = target < start;
      achieved = losing ? current <= target : current >= target;
      fraction = ((start - current) / (start - target)).clamp(0.0, 1.0);
    }
    return GoalProgress(
      goal: goal,
      currentValue: current,
      fraction: achieved ? 1 : fraction,
      isAchieved: achieved,
    );
  }

  GoalProgress _build(Goal goal, double current, List<bool> achievedByPeriod) {
    final fraction = goal.targetValue <= 0
        ? 0.0
        : (current / goal.targetValue).clamp(0.0, 1.0);
    return GoalProgress(
      goal: goal,
      currentValue: current,
      fraction: fraction,
      isAchieved: achievedByPeriod.isNotEmpty && achievedByPeriod.last,
      currentStreak: _currentStreak(achievedByPeriod),
      longestStreak: _longestStreak(achievedByPeriod),
    );
  }

  /// Consecutive achieved periods ending now. The in-progress period doesn't
  /// break the streak while it is still unmet.
  int _currentStreak(List<bool> achieved) {
    var index = achieved.length - 1;
    if (index >= 0 && !achieved[index]) index--;
    var streak = 0;
    while (index >= 0 && achieved[index]) {
      streak++;
      index--;
    }
    return streak;
  }

  int _longestStreak(List<bool> achieved) {
    var longest = 0;
    var run = 0;
    for (final value in achieved) {
      run = value ? run + 1 : 0;
      if (run > longest) longest = run;
    }
    return longest;
  }

  /// Day key → value, for days that have data.
  Future<Map<int, double>> _dailyValues(GoalType type, DateRange range) async {
    switch (type) {
      case GoalType.dailySteps:
        final days = (await _activity.getRange(range)).dataOrNull ?? const [];
        return {for (final d in days) d.date.dayKey: d.steps.toDouble()};
      default:
        return const {};
    }
  }

  /// Week-start day key → value.
  Future<Map<int, double>> _weeklyValues(GoalType type, DateRange range) async {
    final totals = <int, double>{};
    switch (type) {
      case GoalType.weeklyWorkouts:
        final workouts =
            (await _workouts.getCompletedWorkouts(range)).dataOrNull ??
            const [];
        for (final workout in workouts) {
          final key = workout.startedAt.startOfWeek.dayKey;
          totals[key] = (totals[key] ?? 0) + 1;
        }
      case GoalType.weeklyDistance:
        final activities =
            (await _trackedActivities.getActivities(range)).dataOrNull ??
            const [];
        for (final activity in activities) {
          final key = activity.startedAt.startOfWeek.dayKey;
          totals[key] = (totals[key] ?? 0) + activity.distanceMeters;
        }
      default:
        break;
    }
    return totals;
  }
}
