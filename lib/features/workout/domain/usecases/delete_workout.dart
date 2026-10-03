import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/workout/domain/repositories/workout_repository.dart';
import 'package:injectable/injectable.dart';

/// Deletes a finished workout, or discards the active one.
@lazySingleton
class DeleteWorkout implements UseCase<void, String> {
  const DeleteWorkout(this._repository);

  final WorkoutRepository _repository;

  @override
  Future<Result<void>> call(String params) => _repository.deleteWorkout(params);
}
