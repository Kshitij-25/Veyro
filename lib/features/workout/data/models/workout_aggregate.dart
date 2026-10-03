import 'package:fitness_trakcer/core/database/app_database.dart';

/// A workout row together with its exercises and sets, as read from storage.
class WorkoutAggregate {
  const WorkoutAggregate({required this.workout, required this.exercises});

  final WorkoutRow workout;
  final List<WorkoutExerciseAggregate> exercises;
}

class WorkoutExerciseAggregate {
  const WorkoutExerciseAggregate({
    required this.workoutExercise,
    required this.exercise,
    required this.sets,
  });

  final WorkoutExerciseRow workoutExercise;
  final ExerciseRow exercise;
  final List<WorkoutSetRow> sets;
}
