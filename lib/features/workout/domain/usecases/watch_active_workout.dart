import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout.dart';
import 'package:fitness_trakcer/features/workout/domain/repositories/workout_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class WatchActiveWorkout implements StreamUseCase<Workout?, NoParams> {
  const WatchActiveWorkout(this._repository);

  final WorkoutRepository _repository;

  @override
  Stream<Workout?> call(NoParams params) => _repository.watchActiveWorkout();
}
