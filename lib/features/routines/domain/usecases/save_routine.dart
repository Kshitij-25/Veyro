import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/clock.dart';
import 'package:fitness_trakcer/core/utils/id_generator.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/routines/domain/entities/routine.dart';
import 'package:fitness_trakcer/features/routines/domain/entities/routine_draft.dart';
import 'package:fitness_trakcer/features/routines/domain/entities/routine_exercise.dart';
import 'package:fitness_trakcer/features/routines/domain/repositories/routine_repository.dart';
import 'package:injectable/injectable.dart';

/// Creates a routine from a draft, or updates the one the draft came from.
@lazySingleton
class SaveRoutine implements UseCase<Routine, RoutineDraft> {
  const SaveRoutine(this._repository, this._ids, this._clock);

  final RoutineRepository _repository;
  final IdGenerator _ids;
  final Clock _clock;

  @override
  Future<Result<Routine>> call(RoutineDraft params) async {
    if (params.name.trim().isEmpty) {
      return const Fail(ValidationFailure('Routine name is required.'));
    }
    if (params.exercises.isEmpty) {
      return const Fail(ValidationFailure('Add at least one exercise.'));
    }
    if (params.exercises.any((e) => e.targetSets < 1 || e.targetReps < 1)) {
      return const Fail(ValidationFailure('Sets and reps must be at least 1.'));
    }

    var createdAt = _clock.now();
    if (params.id != null) {
      final existing = await _repository.getRoutine(params.id!);
      createdAt = existing.dataOrNull?.createdAt ?? createdAt;
    }

    final routine = Routine(
      id: params.id ?? _ids.generate(),
      name: params.name.trim(),
      notes: params.notes,
      createdAt: createdAt,
      scheduledWeekdays: params.scheduledWeekdays,
      exercises: [
        for (final (index, draft) in params.exercises.indexed)
          RoutineExercise(
            id: _ids.generate(),
            exercise: draft.exercise,
            position: index,
            targetSets: draft.targetSets,
            targetReps: draft.targetReps,
            targetWeightKg: draft.targetWeightKg,
            restSeconds: draft.restSeconds,
          ),
      ],
    );
    final saved = await _repository.saveRoutine(routine);
    return saved.map((_) => routine);
  }
}
