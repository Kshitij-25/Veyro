import 'package:fitness_trakcer/features/goals/domain/entities/goal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal_progress.freezed.dart';

@freezed
abstract class GoalProgress with _$GoalProgress {
  const factory GoalProgress({
    required Goal goal,

    /// Value for the current day/week, or the current weight.
    required double currentValue,

    /// `0..1` share of the target reached.
    required double fraction,
    required bool isAchieved,

    /// Consecutive days/weeks the goal was met (0 for one-off goals).
    @Default(0) int currentStreak,
    @Default(0) int longestStreak,
  }) = _GoalProgress;
}
