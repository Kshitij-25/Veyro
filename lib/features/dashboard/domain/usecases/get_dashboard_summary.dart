import 'package:fitness_trakcer/core/extensions/date_time_extensions.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/clock.dart';
import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/activity/domain/entities/daily_activity.dart';
import 'package:fitness_trakcer/features/activity/domain/repositories/activity_repository.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/usecases/get_latest_weight.dart';
import 'package:fitness_trakcer/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:fitness_trakcer/features/goals/domain/usecases/get_goal_progress.dart';
import 'package:fitness_trakcer/features/routines/domain/usecases/get_routines_for_date.dart';
import 'package:fitness_trakcer/features/workout/domain/repositories/workout_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetDashboardSummary implements UseCase<DashboardSummary, NoParams> {
  const GetDashboardSummary(
    this._activity,
    this._workouts,
    this._getRoutinesForDate,
    this._getLatestWeight,
    this._getGoalProgress,
    this._clock,
  );

  final ActivityRepository _activity;
  final WorkoutRepository _workouts;
  final GetRoutinesForDate _getRoutinesForDate;
  final GetLatestWeight _getLatestWeight;
  final GetGoalProgress _getGoalProgress;
  final Clock _clock;

  @override
  Future<Result<DashboardSummary>> call(NoParams params) => guard(() async {
    final now = _clock.now();
    final today = DateRange.day(now);

    final activity =
        (await _activity.getRange(today)).getOrThrow().firstOrNull ??
        DailyActivity(date: today.start);
    final active = (await _workouts.getActiveWorkout()).getOrThrow();
    final routines = (await _getRoutinesForDate(now)).dataOrNull ?? const [];
    final weekWorkouts = (await _workouts.getCompletedWorkouts(
      DateRange.week(now),
    )).getOrThrow();
    final weight = (await _getLatestWeight(const NoParams())).dataOrNull;
    final goals =
        (await _getGoalProgress(const NoParams())).dataOrNull ?? const [];

    return DashboardSummary(
      date: now.startOfDay,
      activity: activity,
      activeWorkout: active,
      todaysRoutines: routines,
      workoutsThisWeek: weekWorkouts.length,
      latestWeightKg: weight,
      goals: goals,
    );
  });
}
