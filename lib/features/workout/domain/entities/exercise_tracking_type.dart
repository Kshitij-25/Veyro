/// Which values are recorded for each set of an exercise.
enum ExerciseTrackingType {
  weightAndReps,
  repsOnly,
  duration,
  distanceAndDuration;

  bool get tracksWeight => this == weightAndReps;
  bool get tracksReps => this == weightAndReps || this == repsOnly;
  bool get tracksDuration => this == duration || this == distanceAndDuration;
  bool get tracksDistance => this == distanceAndDuration;
}
