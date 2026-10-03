import 'dart:async';

import 'package:fitness_trakcer/core/error/failure_exception.dart';
import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/view_status.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/muscle_group.dart';
import 'package:fitness_trakcer/features/workout/domain/usecases/create_custom_exercise.dart';
import 'package:fitness_trakcer/features/workout/domain/usecases/delete_custom_exercise.dart';
import 'package:fitness_trakcer/features/workout/domain/usecases/get_exercise_sync_status.dart';
import 'package:fitness_trakcer/features/workout/domain/usecases/sync_remote_exercises.dart';
import 'package:fitness_trakcer/features/workout/domain/usecases/watch_exercises.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'exercise_library_cubit.freezed.dart';

@freezed
abstract class ExerciseLibraryState with _$ExerciseLibraryState {
  const factory ExerciseLibraryState({
    @Default(ViewStatus.initial) ViewStatus status,
    @Default([]) List<Exercise> exercises,
    @Default('') String query,
    MuscleGroup? muscleGroup,

    /// The remote catalogue is being downloaded.
    @Default(false) bool isSyncing,

    /// When the remote catalogue was last imported (`null` = never).
    DateTime? lastSyncedAt,

    /// Exercises added by the most recent manual sync, until acknowledged.
    int? lastSyncAdded,
    Failure? failure,
  }) = _ExerciseLibraryState;

  const ExerciseLibraryState._();

  /// Exercises matching the search text and muscle-group filter.
  List<Exercise> get visibleExercises {
    final needle = query.trim().toLowerCase();
    return [
      for (final e in exercises)
        if ((muscleGroup == null || e.muscleGroup == muscleGroup) &&
            (needle.isEmpty || e.name.toLowerCase().contains(needle)))
          e,
    ];
  }
}

@injectable
class ExerciseLibraryCubit extends Cubit<ExerciseLibraryState> {
  ExerciseLibraryCubit(
    this._watchExercises,
    this._createCustomExercise,
    this._deleteCustomExercise,
    this._syncRemoteExercises,
    this._getExerciseSyncStatus,
  ) : super(const ExerciseLibraryState());

  final WatchExercises _watchExercises;
  final CreateCustomExercise _createCustomExercise;
  final DeleteCustomExercise _deleteCustomExercise;
  final SyncRemoteExercises _syncRemoteExercises;
  final GetExerciseSyncStatus _getExerciseSyncStatus;

  StreamSubscription<List<Exercise>>? _subscription;

  void start() {
    emit(state.copyWith(status: ViewStatus.loading));
    unawaited(_loadSyncStatus());
    _subscription = _watchExercises(const NoParams()).listen(
      (exercises) => emit(
        state.copyWith(status: ViewStatus.success, exercises: exercises),
      ),
      onError: (Object error) => emit(
        state.copyWith(status: ViewStatus.failure, failure: toFailure(error)),
      ),
    );
  }

  Future<void> _loadSyncStatus() async {
    final result = await _getExerciseSyncStatus(const NoParams());
    if (!isClosed) emit(state.copyWith(lastSyncedAt: result.dataOrNull));
  }

  /// Downloads more exercises from the wger catalogue.
  Future<void> syncRemote() async {
    if (state.isSyncing) return;
    emit(state.copyWith(isSyncing: true, failure: null, lastSyncAdded: null));
    final result = await _syncRemoteExercises(
      const SyncRemoteExercisesParams(force: true),
    );
    if (isClosed) return;
    emit(
      state.copyWith(
        isSyncing: false,
        failure: result.failureOrNull,
        lastSyncAdded: result.dataOrNull?.added,
      ),
    );
    await _loadSyncStatus();
  }

  void acknowledgeSync() => emit(state.copyWith(lastSyncAdded: null));

  void search(String query) => emit(state.copyWith(query: query));

  void filterByMuscleGroup(MuscleGroup? group) =>
      emit(state.copyWith(muscleGroup: group));

  Future<Exercise?> createCustom(CreateCustomExerciseParams params) async {
    final result = await _createCustomExercise(params);
    emit(state.copyWith(failure: result.failureOrNull));
    return result.dataOrNull;
  }

  Future<void> deleteCustom(String exerciseId) async {
    final result = await _deleteCustomExercise(exerciseId);
    emit(state.copyWith(failure: result.failureOrNull));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
