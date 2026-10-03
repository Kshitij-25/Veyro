import 'dart:async';

import 'package:fitness_trakcer/core/error/failure_exception.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/core/utils/view_status.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout_set.dart';
import 'package:fitness_trakcer/features/workout/domain/usecases/delete_workout.dart';
import 'package:fitness_trakcer/features/workout/domain/usecases/edit_workout.dart';
import 'package:fitness_trakcer/features/workout/domain/usecases/finish_workout.dart';
import 'package:fitness_trakcer/features/workout/domain/usecases/start_workout.dart';
import 'package:fitness_trakcer/features/workout/domain/usecases/watch_active_workout.dart';
import 'package:fitness_trakcer/features/workout/presentation/cubit/active_workout_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// App-wide owner of the workout that is currently being logged. Edits are
/// persisted immediately, so a running workout survives the app being killed.
@lazySingleton
class ActiveWorkoutCubit extends Cubit<ActiveWorkoutState> {
  ActiveWorkoutCubit(
    this._watchActiveWorkout,
    this._startWorkout,
    this._editWorkout,
    this._finishWorkout,
    this._deleteWorkout,
  ) : super(const ActiveWorkoutState());

  final WatchActiveWorkout _watchActiveWorkout;
  final StartWorkout _startWorkout;
  final EditWorkout _editWorkout;
  final FinishWorkout _finishWorkout;
  final DeleteWorkout _deleteWorkout;

  StreamSubscription<Workout?>? _subscription;

  void start() {
    if (_subscription != null) return;
    emit(state.copyWith(status: ViewStatus.loading));
    _subscription = _watchActiveWorkout(const NoParams()).listen(
      (workout) =>
          emit(state.copyWith(status: ViewStatus.success, workout: workout)),
      onError: (Object error) => emit(
        state.copyWith(status: ViewStatus.failure, failure: toFailure(error)),
      ),
    );
  }

  /// Begins a new, empty workout.
  Future<void> beginWorkout({String? name}) => _run(() => _startWorkout(name));

  Future<void> addExercise(Exercise exercise) =>
      _edit(AddExerciseToWorkout(exercise));

  Future<void> removeExercise(String workoutExerciseId) =>
      _edit(RemoveExerciseFromWorkout(workoutExerciseId));

  Future<void> addSet(String workoutExerciseId, {bool isWarmup = false}) =>
      _edit(AddSetToExercise(workoutExerciseId, isWarmup: isWarmup));

  Future<void> updateSet(String workoutExerciseId, WorkoutSet set) =>
      _edit(UpdateSet(workoutExerciseId, set));

  Future<void> removeSet(String workoutExerciseId, String setId) =>
      _edit(RemoveSet(workoutExerciseId, setId));

  Future<void> toggleSetCompleted(String workoutExerciseId, String setId) =>
      _edit(ToggleSetCompleted(workoutExerciseId, setId));

  Future<void> rename(String name) => _edit(RenameWorkout(name));

  Future<void> setNotes(String? notes) => _edit(SetWorkoutNotes(notes));

  /// Finishes the workout; the result is exposed as `finishedWorkout`.
  Future<void> finish() async {
    final id = state.workout?.id;
    if (id == null) return;
    emit(state.copyWith(isBusy: true, failure: null));
    final result = await _finishWorkout(id);
    emit(
      state.copyWith(
        isBusy: false,
        failure: result.failureOrNull,
        finishedWorkout: result.dataOrNull,
      ),
    );
  }

  void acknowledgeFinished() => emit(state.copyWith(finishedWorkout: null));

  /// Deletes the in-progress workout.
  Future<void> discard() async {
    final id = state.workout?.id;
    if (id == null) return;
    await _run(() => _deleteWorkout(id));
  }

  Future<void> _edit(WorkoutEdit edit) async {
    final id = state.workout?.id;
    if (id == null) return;
    final result = await _editWorkout(EditWorkoutParams(id, edit));
    if (result case Fail(:final failure)) {
      emit(state.copyWith(failure: failure));
    }
  }

  Future<void> _run<T>(Future<Result<T>> Function() action) async {
    emit(state.copyWith(isBusy: true, failure: null));
    final result = await action();
    emit(state.copyWith(isBusy: false, failure: result.failureOrNull));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
