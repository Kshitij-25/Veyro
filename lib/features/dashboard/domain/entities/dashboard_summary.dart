import 'package:fitness_trakcer/features/activity/domain/entities/daily_activity.dart';
import 'package:fitness_trakcer/features/activity/domain/entities/health_access_status.dart';
import 'package:fitness_trakcer/features/dashboard/domain/entities/coach_advice.dart';
import 'package:fitness_trakcer/features/goals/domain/entities/goal_progress.dart';
import 'package:fitness_trakcer/features/recovery/domain/entities/recovery_snapshot.dart';
import 'package:fitness_trakcer/features/report/domain/entities/weekly_report.dart';
import 'package:fitness_trakcer/features/routines/domain/entities/routine.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_summary.freezed.dart';

/// A snapshot of today across every feature, for the home screen.
@freezed
abstract class DashboardSummary with _$DashboardSummary {
  const factory DashboardSummary({
    required DateTime date,
    required DailyActivity activity,
    Workout? activeWorkout,
    @Default([]) List<Routine> todaysRoutines,
    @Default(0) int workoutsThisWeek,
    double? latestWeightKg,
    @Default([]) List<GoalProgress> goals,

    /// Whether recovery data can be read (Health connected or not).
    @Default(HealthAccessStatus.unknown) HealthAccessStatus healthAccess,
    RecoverySnapshot? recovery,
    Readiness? readiness,
    CoachAdvice? coach,
    WeeklyReport? weeklyReport,

    /// Calories burned today (workouts, recorded activities or Health).
    @Default(0) int exerciseKcal,
  }) = _DashboardSummary;
}
