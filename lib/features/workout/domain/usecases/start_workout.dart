import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/clock.dart';
import 'package:fitness_trakcer/core/utils/id_generator.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout.dart';
import 'package:fitness_trakcer/features/workout/domain/repositories/workout_repository.dart';
import 'package:injectable/injectable.dart';

/// Starts an empty workout. Only one workout may be active at a time.
@lazySingleton
class StartWorkout implements UseCase<Workout, String?> {
  const StartWorkout(this._repository, this._ids, this._clock);

  final WorkoutRepository _repository;
  final IdGenerator _ids;
  final Clock _clock;

  @override
  Future<Result<Workout>> call(String? name) async {
    final active = await _repository.getActiveWorkout();
    if (active case Fail(:final failure)) return Fail(failure);
    if (active.dataOrNull != null) {
      return const Fail(ValidationFailure('A workout is already in progress.'));
    }

    final now = _clock.now();
    final workout = Workout(
      id: _ids.generate(),
      name: (name == null || name.trim().isEmpty) ? 'Workout' : name.trim(),
      startedAt: now,
    );
    final saved = await _repository.saveWorkout(workout);
    return saved.map((_) => workout);
  }
}
