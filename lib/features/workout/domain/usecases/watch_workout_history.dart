import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout.dart';
import 'package:fitness_trakcer/features/workout/domain/repositories/workout_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class WatchWorkoutHistory implements StreamUseCase<List<Workout>, NoParams> {
  const WatchWorkoutHistory(this._repository);

  final WorkoutRepository _repository;

  @override
  Stream<List<Workout>> call(NoParams params) =>
      _repository.watchCompletedWorkouts();
}
