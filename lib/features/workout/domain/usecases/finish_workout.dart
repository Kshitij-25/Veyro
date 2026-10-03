import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/calorie_estimator.dart';
import 'package:fitness_trakcer/core/utils/clock.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/usecases/get_latest_weight.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout.dart';
import 'package:fitness_trakcer/features/workout/domain/repositories/workout_repository.dart';
import 'package:injectable/injectable.dart';

/// Ends the workout with the given id: drops exercises that have no completed
/// sets, stamps the end time and estimates the calories burned.
@lazySingleton
class FinishWorkout implements UseCase<Workout, String> {
  const FinishWorkout(this._repository, this._getLatestWeight, this._clock);

  /// Average MET for resistance training.
  static const _strengthTrainingMet = 5.0;
  static const _fallbackWeightKg = 70.0;

  final WorkoutRepository _repository;
  final GetLatestWeight _getLatestWeight;
  final Clock _clock;

  @override
  Future<Result<Workout>> call(String params) async {
    final weightKg =
        (await _getLatestWeight(const NoParams())).dataOrNull ??
        _fallbackWeightKg;
    final now = _clock.now();

    final current = await _repository.getWorkout(params);
    if (current case Fail(:final failure)) return Fail(failure);
    final workout = current.dataOrNull!;
    if (!workout.isActive) {
      return const Fail(ValidationFailure('This workout is already finished.'));
    }

    return _repository.updateWorkout(params, (w) {
      final performed = [
        for (final e in w.exercises)
          if (e.completedSetCount > 0)
            e.copyWith(
              sets: [
                for (final s in e.sets)
                  if (s.isCompleted) s,
              ],
            ),
      ];
      final duration = now.difference(w.startedAt);
      return w.copyWith(
        exercises: [
          for (var i = 0; i < performed.length; i++)
            performed[i].copyWith(position: i),
        ],
        endedAt: now,
        caloriesBurned: CalorieEstimator.fromMet(
          met: _strengthTrainingMet,
          weightKg: weightKg,
          duration: duration,
        ),
      );
    });
  }
}
