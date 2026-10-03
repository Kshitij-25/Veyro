enum Equipment {
  barbell('Barbell'),
  dumbbell('Dumbbell'),
  machine('Machine'),
  cable('Cable'),
  kettlebell('Kettlebell'),
  bodyweight('Bodyweight'),
  other('Other');

  const Equipment(this.label);

  final String label;
}
