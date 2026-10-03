import 'package:fitness_trakcer/core/units/unit_converter.dart';
import 'package:fitness_trakcer/core/units/unit_system.dart';

/// Formats stored metric values as human-readable strings in the user's units.
extension UnitFormatter on UnitSystem {
  String formatWeight(double kg, {int decimals = 1}) =>
      '${UnitConverter.weightToDisplay(kg, this).toStringAsFixed(decimals)} $weightUnit';

  String formatLength(double cm, {int decimals = 1}) =>
      '${UnitConverter.lengthToDisplay(cm, this).toStringAsFixed(decimals)} $lengthUnit';

  String formatDistance(double meters, {int decimals = 2}) =>
      '${UnitConverter.distanceToDisplay(meters, this).toStringAsFixed(decimals)} $distanceUnit';

  /// Pace as `m:ss /km` or `m:ss /mi` from seconds per kilometre.
  String formatPace(double secondsPerKm) {
    if (secondsPerKm.isNaN || secondsPerKm.isInfinite || secondsPerKm <= 0) {
      return '--:-- /$distanceUnit';
    }
    final perUnit = this == UnitSystem.metric
        ? secondsPerKm
        : secondsPerKm * UnitConverter.metersToMiles(1000);
    final total = perUnit.round();
    final minutes = total ~/ 60;
    final seconds = (total % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds /$distanceUnit';
  }
}

extension DurationFormatter on Duration {
  /// `h:mm:ss` when at least an hour, otherwise `mm:ss`.
  String get clock {
    final hours = inHours;
    final minutes = (inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (inSeconds % 60).toString().padLeft(2, '0');
    return hours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }
}
