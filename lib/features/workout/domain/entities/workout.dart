import 'package:fitness_trakcer/features/workout/domain/entities/workout_exercise.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout.freezed.dart';

@freezed
abstract class Workout with _$Workout {
  const factory Workout({
    required String id,
    required String name,
    required DateTime startedAt,
    DateTime? endedAt,
    String? routineId,
    String? notes,
    double? caloriesBurned,
    @Default([]) List<WorkoutExercise> exercises,
  }) = _Workout;

  const Workout._();

  /// A workout without an end time is still in progress.
  bool get isActive => endedAt == null;

  Duration durationAt(DateTime now) => (endedAt ?? now).difference(startedAt);

  double get totalVolumeKg => exercises.fold(0, (sum, e) => sum + e.volumeKg);

  int get completedSetCount =>
      exercises.fold(0, (sum, e) => sum + e.completedSetCount);
}
