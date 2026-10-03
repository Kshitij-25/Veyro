import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout.dart';
import 'package:fitness_trakcer/features/workout/domain/repositories/workout_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetActiveWorkout implements UseCase<Workout?, NoParams> {
  const GetActiveWorkout(this._repository);

  final WorkoutRepository _repository;

  @override
  Future<Result<Workout?>> call(NoParams params) =>
      _repository.getActiveWorkout();
}
