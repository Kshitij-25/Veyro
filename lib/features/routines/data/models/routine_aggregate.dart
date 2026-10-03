import 'package:fitness_trakcer/core/database/app_database.dart';

class RoutineAggregate {
  const RoutineAggregate({required this.routine, required this.exercises});

  final RoutineRow routine;
  final List<RoutineExerciseAggregate> exercises;
}

class RoutineExerciseAggregate {
  const RoutineExerciseAggregate({
    required this.routineExercise,
    required this.exercise,
  });

  final RoutineExerciseRow routineExercise;
  final ExerciseRow exercise;
}
