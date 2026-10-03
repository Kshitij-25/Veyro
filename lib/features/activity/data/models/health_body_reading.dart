/// A weight and/or body-fat reading from the platform health store.
class HealthBodyReading {
  const HealthBodyReading({
    required this.measuredAt,
    this.weightKg,
    this.bodyFatPercent,
  });

  final DateTime measuredAt;
  final double? weightKg;
  final double? bodyFatPercent;
}
