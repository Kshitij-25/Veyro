enum Sex {
  male,
  female,
  other;

  String get label => switch (this) {
    Sex.male => 'Male',
    Sex.female => 'Female',
    Sex.other => 'Other',
  };
}
