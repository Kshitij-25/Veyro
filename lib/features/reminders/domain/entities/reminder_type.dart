enum ReminderType {
  workout('Workout'),
  weighIn('Weigh-in'),
  custom('Custom');

  const ReminderType(this.label);

  final String label;
}
