import 'package:fitness_trakcer/core/units/unit_converter.dart';
import 'package:fitness_trakcer/core/units/unit_system.dart';

/// Formatting helpers for the sample-data screens.
extension WellnessFormat on UnitSystem {
  bool get isImperial => this == UnitSystem.imperial;

  /// Weight in kg as a one-decimal string in this system's unit.
  String fw(double kg) =>
      (UnitConverter.weightToDisplay(kg, this)).toStringAsFixed(1);

  /// Distance in km, [d] decimals.
  String fd(double km, [int d = 1]) =>
      UnitConverter.distanceToDisplay(km * 1000, this).toStringAsFixed(d);

  /// Length in cm, one decimal.
  String fl(double cm) =>
      UnitConverter.lengthToDisplay(cm, this).toStringAsFixed(1);

  double get kgFactor => isImperial ? 2.2046226218 : 1;
  double get kmFactor => isImperial ? 0.621371 : 1;

  String get waterUnit => isImperial ? 'oz' : 'ml';

  int waterDisplay(int ml) => isImperial ? (ml / 29.57).round() : ml;
}

/// `m:ss` or `h:mm:ss` from whole seconds.
String clockText(num seconds) {
  final s = seconds.round();
  final h = s ~/ 3600;
  final m = (s % 3600) ~/ 60;
  final c = s % 60;
  String p(int n) => n.toString().padLeft(2, '0');
  return h > 0 ? '$h:${p(m)}:${p(c)}' : '$m:${p(c)}';
}

String thousands(num n) {
  final s = n.round().toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
    b.write(s[i]);
  }
  return b.toString();
}
