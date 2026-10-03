import 'package:fitness_trakcer/core/units/unit_system.dart';

/// Conversions between the metric values we store and the user's display unit.
abstract final class UnitConverter {
  static const _lbPerKg = 2.2046226218;
  static const _cmPerInch = 2.54;
  static const _metersPerMile = 1609.344;

  static double kgToLb(double kg) => kg * _lbPerKg;
  static double lbToKg(double lb) => lb / _lbPerKg;

  static double cmToInches(double cm) => cm / _cmPerInch;
  static double inchesToCm(double inches) => inches * _cmPerInch;

  static double metersToKm(double meters) => meters / 1000;
  static double metersToMiles(double meters) => meters / _metersPerMile;
  static double kmToMeters(double km) => km * 1000;
  static double milesToMeters(double miles) => miles * _metersPerMile;

  /// Converts a stored metric weight (kg) to the display unit of [system].
  static double weightToDisplay(double kg, UnitSystem system) =>
      system == UnitSystem.metric ? kg : kgToLb(kg);

  static double weightFromDisplay(double value, UnitSystem system) =>
      system == UnitSystem.metric ? value : lbToKg(value);

  static double lengthToDisplay(double cm, UnitSystem system) =>
      system == UnitSystem.metric ? cm : cmToInches(cm);

  static double lengthFromDisplay(double value, UnitSystem system) =>
      system == UnitSystem.metric ? value : inchesToCm(value);

  static double distanceToDisplay(double meters, UnitSystem system) =>
      system == UnitSystem.metric ? metersToKm(meters) : metersToMiles(meters);

  static double distanceFromDisplay(double value, UnitSystem system) =>
      system == UnitSystem.metric ? kmToMeters(value) : milesToMeters(value);
}
