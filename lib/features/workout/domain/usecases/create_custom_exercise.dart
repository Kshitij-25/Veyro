import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/id_generator.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/equipment.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise_source.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise_tracking_type.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/muscle_group.dart';
import 'package:fitness_trakcer/features/workout/domain/repositories/exercise_repository.dart';
import 'package:injectable/injectable.dart';

class CreateCustomExerciseParams {
  const CreateCustomExerciseParams({
    required this.name,
    required this.muscleGroup,
    this.equipment = Equipment.other,
    this.trackingType = ExerciseTrackingType.weightAndReps,
  });

  final String name;
  final MuscleGroup muscleGroup;
  final Equipment equipment;
  final ExerciseTrackingType trackingType;
}

@lazySingleton
class CreateCustomExercise
    implements UseCase<Exercise, CreateCustomExerciseParams> {
  const CreateCustomExercise(this._repository, this._ids);

  final ExerciseRepository _repository;
  final IdGenerator _ids;

  @override
  Future<Result<Exercise>> call(CreateCustomExerciseParams params) async {
    final name = params.name.trim();
    if (name.isEmpty) {
      return const Fail(ValidationFailure('Exercise name is required.'));
    }
    final exercise = Exercise(
      id: _ids.generate(),
      name: name,
      muscleGroup: params.muscleGroup,
      equipment: params.equipment,
      trackingType: params.trackingType,
      source: ExerciseSource.custom,
    );
    final saved = await _repository.saveExercise(exercise);
    return saved.map((_) => exercise);
  }
}
