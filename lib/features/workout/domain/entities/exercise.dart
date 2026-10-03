import 'package:fitness_trakcer/features/workout/domain/entities/equipment.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise_source.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise_tracking_type.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/muscle_group.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise.freezed.dart';

@freezed
abstract class Exercise with _$Exercise {
  const factory Exercise({
    required String id,
    required String name,
    required MuscleGroup muscleGroup,
    required Equipment equipment,
    required ExerciseTrackingType trackingType,
    @Default(ExerciseSource.builtin) ExerciseSource source,

    /// Identifier in the remote catalogue, for imported exercises.
    String? remoteId,
    String? imageUrl,
    String? description,
  }) = _Exercise;

  const Exercise._();

  bool get isCustom => source == ExerciseSource.custom;
}
