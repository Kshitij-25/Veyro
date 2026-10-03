import 'dart:async';

import 'package:fitness_trakcer/core/error/failure_exception.dart';
import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/view_status.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout.dart';
import 'package:fitness_trakcer/features/workout/domain/usecases/delete_workout.dart';
import 'package:fitness_trakcer/features/workout/domain/usecases/watch_workout_history.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'workout_history_cubit.freezed.dart';

@freezed
abstract class WorkoutHistoryState with _$WorkoutHistoryState {
  const factory WorkoutHistoryState({
    @Default(ViewStatus.initial) ViewStatus status,

    /// Newest first.
    @Default([]) List<Workout> workouts,
    Failure? failure,
  }) = _WorkoutHistoryState;
}

@injectable
class WorkoutHistoryCubit extends Cubit<WorkoutHistoryState> {
  WorkoutHistoryCubit(this._watchHistory, this._deleteWorkout)
    : super(const WorkoutHistoryState());

  final WatchWorkoutHistory _watchHistory;
  final DeleteWorkout _deleteWorkout;

  StreamSubscription<List<Workout>>? _subscription;

  void start() {
    emit(state.copyWith(status: ViewStatus.loading));
    _subscription = _watchHistory(const NoParams()).listen(
      (workouts) =>
          emit(state.copyWith(status: ViewStatus.success, workouts: workouts)),
      onError: (Object error) => emit(
        state.copyWith(status: ViewStatus.failure, failure: toFailure(error)),
      ),
    );
  }

  Future<void> delete(String workoutId) async {
    final result = await _deleteWorkout(workoutId);
    if (result.failureOrNull case final failure?) {
      emit(state.copyWith(failure: failure));
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
