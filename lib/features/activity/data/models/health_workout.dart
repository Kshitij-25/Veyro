/// A cardio workout recorded by a watch or another app in the health store.
class HealthWorkout {
  const HealthWorkout({
    required this.uuid,
    required this.kind,
    required this.title,
    required this.start,
    required this.end,
    required this.distanceMeters,
    required this.caloriesKcal,
    this.source,
  });

  final String uuid;

  /// `run`, `walk`, `cycle` or `other`.
  final String kind;

  /// Readable name of the workout type, e.g. "Yoga".
  final String title;
  final DateTime start;
  final DateTime end;
  final double distanceMeters;
  final double caloriesKcal;
  final String? source;
}
