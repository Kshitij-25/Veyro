import 'package:fitness_trakcer/core/extensions/date_time_extensions.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/clock.dart';
import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/activity/domain/entities/daily_activity.dart';
import 'package:fitness_trakcer/features/activity/domain/entities/health_access_status.dart';
import 'package:fitness_trakcer/features/activity/domain/repositories/activity_repository.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/usecases/get_latest_weight.dart';
import 'package:fitness_trakcer/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:fitness_trakcer/features/dashboard/domain/services/coach_advisor.dart';
import 'package:fitness_trakcer/features/goals/domain/usecases/get_goal_progress.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/repositories/tracked_activity_repository.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/services/training_sessions.dart';
import 'package:fitness_trakcer/features/recovery/domain/entities/readiness_calculator.dart';
import 'package:fitness_trakcer/features/recovery/domain/entities/recovery_snapshot.dart';
import 'package:fitness_trakcer/features/recovery/domain/usecases/get_recovery_snapshot.dart';
import 'package:fitness_trakcer/features/report/domain/usecases/get_weekly_report.dart';
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
    this._getRecovery,
    this._getWeeklyReport,
    this._tracked,
    this._clock,
  );

  final ActivityRepository _activity;
  final WorkoutRepository _workouts;
  final GetRoutinesForDate _getRoutinesForDate;
  final GetLatestWeight _getLatestWeight;
  final GetGoalProgress _getGoalProgress;
  final GetRecoverySnapshot _getRecovery;
  final GetWeeklyReport _getWeeklyReport;
  final TrackedActivityRepository _tracked;
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
    final weekTracked =
        (await _tracked.getActivities(DateRange.week(now))).dataOrNull ??
        const [];
    final weekSessions = TrainingSessions.merge(
      weekWorkouts,
      weekTracked,
      now: now,
    );
    final weight = (await _getLatestWeight(const NoParams())).dataOrNull;
    final goals =
        (await _getGoalProgress(const NoParams())).dataOrNull ?? const [];

    // Recovery needs Health. iOS never reports read access, so try anyway
    // unless it is known to be unavailable or not granted.
    final access =
        (await _activity.getHealthAccessStatus()).dataOrNull ??
        HealthAccessStatus.unknown;
    RecoverySnapshot? recovery;
    Readiness? readiness;
    if (access == HealthAccessStatus.granted ||
        access == HealthAccessStatus.unknown) {
      recovery = (await _getRecovery(const NoParams())).dataOrNull;
      if (recovery != null && recovery.hasData) {
        readiness = ReadinessCalculator.compute(recovery);
      } else {
        recovery = null;
      }
    }

    final recentWorkouts =
        (await _workouts.getCompletedWorkouts(
          DateRange.lastDays(14, until: now),
        )).dataOrNull ??
        const [];
    final coach = CoachAdvisor.advise(
      readiness: readiness,
      todaysRoutines: routines,
      workouts: recentWorkouts,
      now: now,
    );
    final weekly = (await _getWeeklyReport(const NoParams())).dataOrNull;

    final todayKcal =
        recentWorkouts
            .where((w) => today.contains(w.startedAt))
            .fold<double>(0, (a, w) => a + (w.caloriesBurned ?? 0)) +
        ((await _tracked.getActivities(today)).dataOrNull ?? const [])
            .fold<double>(0, (a, t) => a + t.caloriesKcal);
    final exerciseKcal = todayKcal > activity.activeCaloriesKcal
        ? todayKcal
        : activity.activeCaloriesKcal;

    return DashboardSummary(
      date: now.startOfDay,
      activity: activity,
      activeWorkout: active,
      todaysRoutines: routines,
      workoutsThisWeek: weekSessions.length,
      latestWeightKg: weight,
      goals: goals,
      healthAccess: access,
      recovery: recovery,
      readiness: readiness,
      coach: coach,
      weeklyReport: weekly,
      exerciseKcal: exerciseKcal.round(),
    );
  });
}
