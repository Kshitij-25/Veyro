import 'package:fitness_trakcer/features/goals/domain/entities/goal_period.dart';

enum GoalType {
  dailySteps('Daily steps', GoalPeriod.daily),
  weeklyWorkouts('Workouts per week', GoalPeriod.weekly),
  weeklyDistance('Weekly distance', GoalPeriod.weekly),
  targetWeight('Target weight', GoalPeriod.overall);

  const GoalType(this.label, this.period);

  final String label;
  final GoalPeriod period;

  /// Whether [value] satisfies [target] for goals that are not weight-based.
  bool isMet(double value, double target) => value >= target;
}
