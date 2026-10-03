enum MuscleGroup {
  chest('Chest'),
  back('Back'),
  shoulders('Shoulders'),
  biceps('Biceps'),
  triceps('Triceps'),
  legs('Legs'),
  glutes('Glutes'),
  core('Core'),
  fullBody('Full body'),
  cardio('Cardio');

  const MuscleGroup(this.label);

  final String label;
}
