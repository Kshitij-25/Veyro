import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/workout/domain/repositories/exercise_repository.dart';
import 'package:injectable/injectable.dart';

/// When the remote exercise catalogue was last imported (`null` = never).
@lazySingleton
class GetExerciseSyncStatus implements UseCase<DateTime?, NoParams> {
  const GetExerciseSyncStatus(this._repository);

  final ExerciseRepository _repository;

  @override
  Future<Result<DateTime?>> call(NoParams params) =>
      _repository.getLastRemoteSync();
}
