/// Typical weekly activity, used to scale BMR into daily energy expenditure.
enum ActivityLevel {
  sedentary(1.2, 'Sedentary'),
  lightlyActive(1.375, 'Lightly active'),
  moderatelyActive(1.55, 'Moderately active'),
  veryActive(1.725, 'Very active'),
  extremelyActive(1.9, 'Extremely active');

  const ActivityLevel(this.multiplier, this.label);

  final double multiplier;
  final String label;
}
