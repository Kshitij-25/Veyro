import 'package:fitness_trakcer/features/goals/domain/entities/goal_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal.freezed.dart';

/// A target the user is working towards.
///
/// [targetValue] uses metric base units: steps, kcal, ml, workouts, metres
/// (weekly distance) and kilograms (target weight).
@freezed
abstract class Goal with _$Goal {
  const factory Goal({
    required String id,
    required GoalType type,
    required double targetValue,
    required DateTime startDate,
    required DateTime createdAt,

    /// Baseline when the goal was set (the starting weight for weight goals).
    double? startValue,
    DateTime? deadline,
    @Default(true) bool isActive,
  }) = _Goal;
}
