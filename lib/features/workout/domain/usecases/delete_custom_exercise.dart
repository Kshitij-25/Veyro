import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/workout/domain/repositories/exercise_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DeleteCustomExercise implements UseCase<void, String> {
  const DeleteCustomExercise(this._repository);

  final ExerciseRepository _repository;

  @override
  Future<Result<void>> call(String params) =>
      _repository.deleteExercise(params);
}
