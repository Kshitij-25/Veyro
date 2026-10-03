import 'package:fitness_trakcer/features/workout/domain/entities/exercise.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout_set.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_exercise.freezed.dart';

/// An [Exercise] performed within a particular workout, with its sets.
@freezed
abstract class WorkoutExercise with _$WorkoutExercise {
  const factory WorkoutExercise({
    required String id,
    required Exercise exercise,
    required int position,
    @Default([]) List<WorkoutSet> sets,
    String? notes,
  }) = _WorkoutExercise;

  const WorkoutExercise._();

  double get volumeKg => sets.fold(0, (sum, set) => sum + set.volumeKg);

  int get completedSetCount => sets.where((s) => s.isCompleted).length;
}
