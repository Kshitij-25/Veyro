/// Outdoor activities that can be recorded with GPS.
enum TrackedActivityType {
  run('Run'),
  walk('Walk'),
  cycle('Cycle');

  const TrackedActivityType(this.label);

  final String label;

  /// Highest plausible speed; faster GPS jumps are treated as noise.
  double get maxSpeedMetersPerSecond => switch (this) {
    TrackedActivityType.cycle => 25,
    _ => 12,
  };

  /// MET value for the average speed [kmh].
  double met(double kmh) => switch (this) {
    TrackedActivityType.walk => kmh < 4 ? 2.8 : (kmh < 5.5 ? 3.5 : 4.3),
    TrackedActivityType.run =>
      kmh < 8 ? 8.3 : (kmh < 10 ? 9.8 : (kmh < 12 ? 11.0 : 12.5)),
    TrackedActivityType.cycle =>
      kmh < 16 ? 6.8 : (kmh < 20 ? 8.0 : (kmh < 25 ? 10.0 : 12.0)),
  };
}
