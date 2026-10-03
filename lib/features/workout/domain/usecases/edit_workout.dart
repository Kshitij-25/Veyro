import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/id_generator.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout_exercise.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout_set.dart';
import 'package:fitness_trakcer/features/workout/domain/repositories/workout_repository.dart';
import 'package:injectable/injectable.dart';

/// A single user edit to a workout. Applying commands through
/// [EditWorkout] keeps ordering, ids and persistence consistent.
sealed class WorkoutEdit {
  const WorkoutEdit();
}

final class RenameWorkout extends WorkoutEdit {
  const RenameWorkout(this.name);
  final String name;
}

final class SetWorkoutNotes extends WorkoutEdit {
  const SetWorkoutNotes(this.notes);
  final String? notes;
}

final class AddExerciseToWorkout extends WorkoutEdit {
  const AddExerciseToWorkout(this.exercise);
  final Exercise exercise;
}

final class RemoveExerciseFromWorkout extends WorkoutEdit {
  const RemoveExerciseFromWorkout(this.workoutExerciseId);
  final String workoutExerciseId;
}

/// Adds a set pre-filled with the values of the exercise's previous set.
final class AddSetToExercise extends WorkoutEdit {
  const AddSetToExercise(this.workoutExerciseId, {this.isWarmup = false});
  final String workoutExerciseId;
  final bool isWarmup;
}

final class UpdateSet extends WorkoutEdit {
  const UpdateSet(this.workoutExerciseId, this.set);
  final String workoutExerciseId;
  final WorkoutSet set;
}

final class RemoveSet extends WorkoutEdit {
  const RemoveSet(this.workoutExerciseId, this.setId);
  final String workoutExerciseId;
  final String setId;
}

final class ToggleSetCompleted extends WorkoutEdit {
  const ToggleSetCompleted(this.workoutExerciseId, this.setId);
  final String workoutExerciseId;
  final String setId;
}

final class EditWorkoutParams {
  const EditWorkoutParams(this.workoutId, this.edit);

  final String workoutId;
  final WorkoutEdit edit;
}

@lazySingleton
class EditWorkout implements UseCase<Workout, EditWorkoutParams> {
  const EditWorkout(this._repository, this._ids);

  final WorkoutRepository _repository;
  final IdGenerator _ids;

  @override
  Future<Result<Workout>> call(EditWorkoutParams params) =>
      _repository.updateWorkout(
        params.workoutId,
        (workout) => _apply(workout, params.edit),
      );

  Workout _apply(Workout workout, WorkoutEdit edit) {
    return switch (edit) {
      RenameWorkout(:final name) => workout.copyWith(
        name: name.trim().isEmpty ? workout.name : name.trim(),
      ),
      SetWorkoutNotes(:final notes) => workout.copyWith(notes: notes),
      AddExerciseToWorkout(:final exercise) => workout.copyWith(
        exercises: [
          ...workout.exercises,
          WorkoutExercise(
            id: _ids.generate(),
            exercise: exercise,
            position: workout.exercises.length,
            sets: [WorkoutSet(id: _ids.generate(), position: 0)],
          ),
        ],
      ),
      RemoveExerciseFromWorkout(:final workoutExerciseId) => workout.copyWith(
        exercises: [
          for (final e in workout.exercises)
            if (e.id != workoutExerciseId) e,
        ].indexed.map((r) => r.$2.copyWith(position: r.$1)).toList(),
      ),
      AddSetToExercise(:final workoutExerciseId, :final isWarmup) =>
        _editExercise(workout, workoutExerciseId, (e) {
          final previous = e.sets.isEmpty ? null : e.sets.last;
          return e.copyWith(
            sets: [
              ...e.sets,
              WorkoutSet(
                id: _ids.generate(),
                position: e.sets.length,
                reps: previous?.reps,
                weightKg: previous?.weightKg,
                durationSeconds: previous?.durationSeconds,
                distanceMeters: previous?.distanceMeters,
                isWarmup: isWarmup,
              ),
            ],
          );
        }),
      UpdateSet(:final workoutExerciseId, :final set) => _editExercise(
        workout,
        workoutExerciseId,
        (e) => e.copyWith(
          sets: [for (final s in e.sets) s.id == set.id ? set : s],
        ),
      ),
      RemoveSet(:final workoutExerciseId, :final setId) => _editExercise(
        workout,
        workoutExerciseId,
        (e) => e.copyWith(
          sets: [
            for (final s in e.sets)
              if (s.id != setId) s,
          ].indexed.map((r) => r.$2.copyWith(position: r.$1)).toList(),
        ),
      ),
      ToggleSetCompleted(:final workoutExerciseId, :final setId) =>
        _editExercise(
          workout,
          workoutExerciseId,
          (e) => e.copyWith(
            sets: [
              for (final s in e.sets)
                s.id == setId ? s.copyWith(isCompleted: !s.isCompleted) : s,
            ],
          ),
        ),
    };
  }

  Workout _editExercise(
    Workout workout,
    String workoutExerciseId,
    WorkoutExercise Function(WorkoutExercise) edit,
  ) => workout.copyWith(
    exercises: [
      for (final e in workout.exercises)
        e.id == workoutExerciseId ? edit(e) : e,
    ],
  );
}
