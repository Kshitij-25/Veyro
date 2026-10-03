import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/personal_record.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout.dart';
import 'package:fitness_trakcer/features/workout/domain/repositories/workout_repository.dart';
import 'package:injectable/injectable.dart';

/// Best lifts per exercise, derived from the completed working sets in history.
@lazySingleton
class GetPersonalRecords implements UseCase<List<PersonalRecord>, NoParams> {
  const GetPersonalRecords(this._repository);

  final WorkoutRepository _repository;

  @override
  Future<Result<List<PersonalRecord>>> call(NoParams params) async {
    final history = await _repository.getCompletedWorkouts(
      DateRange(DateTime(1970), DateTime(2100)),
    );
    return history.map(_computeRecords);
  }

  List<PersonalRecord> _computeRecords(List<Workout> workouts) {
    final records = <String, PersonalRecord>{};
    for (final workout in workouts) {
      for (final entry in workout.exercises) {
        for (final set in entry.sets) {
          final weight = set.weightKg;
          final reps = set.reps;
          if (!set.isCompleted ||
              set.isWarmup ||
              weight == null ||
              reps == null) {
            continue;
          }
          final oneRepMax = _epleyOneRepMax(weight, reps);
          final current = records[entry.exercise.id];
          if (current == null) {
            records[entry.exercise.id] = PersonalRecord(
              exercise: entry.exercise,
              maxWeightKg: weight,
              maxReps: reps,
              estimatedOneRepMaxKg: oneRepMax,
              achievedAt: workout.startedAt,
            );
            continue;
          }
          records[entry.exercise.id] = current.copyWith(
            maxWeightKg: weight > current.maxWeightKg
                ? weight
                : current.maxWeightKg,
            maxReps: reps > current.maxReps ? reps : current.maxReps,
            estimatedOneRepMaxKg: oneRepMax > current.estimatedOneRepMaxKg
                ? oneRepMax
                : current.estimatedOneRepMaxKg,
            achievedAt: oneRepMax > current.estimatedOneRepMaxKg
                ? workout.startedAt
                : current.achievedAt,
          );
        }
      }
    }
    return records.values.toList()
      ..sort((a, b) => a.exercise.name.compareTo(b.exercise.name));
  }

  double _epleyOneRepMax(double weight, int reps) =>
      reps <= 1 ? weight : weight * (1 + reps / 30);
}
