/// Totals read from the platform health store for one day.
class HealthDaySummary {
  const HealthDaySummary({
    required this.date,
    required this.steps,
    required this.distanceMeters,
    required this.activeCaloriesKcal,
  });

  final DateTime date;
  final int steps;
  final double distanceMeters;
  final double activeCaloriesKcal;
}
