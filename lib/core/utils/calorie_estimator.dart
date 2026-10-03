/// Energy expenditure estimates based on Metabolic Equivalent of Task (MET).
abstract final class CalorieEstimator {
  /// kcal = MET × body weight (kg) × duration (hours).
  static double fromMet({
    required double met,
    required double weightKg,
    required Duration duration,
  }) => met * weightKg * (duration.inSeconds / 3600);
}
