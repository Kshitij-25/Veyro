import 'package:fitness_trakcer/core/units/unit_converter.dart';
import 'package:fitness_trakcer/core/units/unit_system.dart';
import 'package:fitness_trakcer/features/goals/domain/entities/goal_type.dart';

/// Converts goal values between metric base units and display units.
extension GoalTypeDisplay on GoalType {
  String unitLabel(UnitSystem units) => switch (this) {
    GoalType.dailySteps => 'steps',
    GoalType.weeklyWorkouts => 'workouts',
    GoalType.weeklyDistance => units.distanceUnit,
    GoalType.targetWeight => units.weightUnit,
  };

  double toDisplay(double value, UnitSystem units) => switch (this) {
    GoalType.weeklyDistance => UnitConverter.distanceToDisplay(value, units),
    GoalType.targetWeight => UnitConverter.weightToDisplay(value, units),
    _ => value,
  };

  double fromDisplay(double value, UnitSystem units) => switch (this) {
    GoalType.weeklyDistance => UnitConverter.distanceFromDisplay(value, units),
    GoalType.targetWeight => UnitConverter.weightFromDisplay(value, units),
    _ => value,
  };

  String format(double value, UnitSystem units) {
    final display = toDisplay(value, units);
    final text = display == display.roundToDouble()
        ? display.toStringAsFixed(0)
        : display.toStringAsFixed(1);
    return '$text ${unitLabel(units)}';
  }
}
