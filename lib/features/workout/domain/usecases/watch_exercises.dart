import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise.dart';
import 'package:fitness_trakcer/features/workout/domain/repositories/exercise_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class WatchExercises implements StreamUseCase<List<Exercise>, NoParams> {
  const WatchExercises(this._repository);

  final ExerciseRepository _repository;

  @override
  Stream<List<Exercise>> call(NoParams params) => _repository.watchExercises();
}
