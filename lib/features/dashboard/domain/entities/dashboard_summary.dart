import 'package:fitness_trakcer/features/activity/domain/entities/daily_activity.dart';
import 'package:fitness_trakcer/features/goals/domain/entities/goal_progress.dart';
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
  }) = _DashboardSummary;
}
