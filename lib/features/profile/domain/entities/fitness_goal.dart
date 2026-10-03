enum FitnessGoal {
  loseWeight(-0.20, 'Lose weight'),
  maintainWeight(0, 'Maintain weight'),
  buildMuscle(0.10, 'Build muscle');

  const FitnessGoal(this.calorieAdjustment, this.label);

  /// Fraction of maintenance calories to add (or subtract when negative).
  final double calorieAdjustment;
  final String label;
}
