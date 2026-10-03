import 'dart:async';

import 'package:fitness_trakcer/core/error/failure_exception.dart';
import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/view_status.dart';
import 'package:fitness_trakcer/features/routines/domain/entities/routine.dart';
import 'package:fitness_trakcer/features/routines/domain/usecases/delete_routine.dart';
import 'package:fitness_trakcer/features/routines/domain/usecases/start_workout_from_routine.dart';
import 'package:fitness_trakcer/features/routines/domain/usecases/watch_routines.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'routines_cubit.freezed.dart';

@freezed
abstract class RoutinesState with _$RoutinesState {
  const factory RoutinesState({
    @Default(ViewStatus.initial) ViewStatus status,
    @Default([]) List<Routine> routines,
    Failure? failure,
  }) = _RoutinesState;
}

@injectable
class RoutinesCubit extends Cubit<RoutinesState> {
  RoutinesCubit(
    this._watchRoutines,
    this._deleteRoutine,
    this._startWorkoutFromRoutine,
  ) : super(const RoutinesState());

  final WatchRoutines _watchRoutines;
  final DeleteRoutine _deleteRoutine;
  final StartWorkoutFromRoutine _startWorkoutFromRoutine;

  StreamSubscription<List<Routine>>? _subscription;

  void start() {
    emit(state.copyWith(status: ViewStatus.loading));
    _subscription = _watchRoutines(const NoParams()).listen(
      (routines) =>
          emit(state.copyWith(status: ViewStatus.success, routines: routines)),
      onError: (Object error) => emit(
        state.copyWith(status: ViewStatus.failure, failure: toFailure(error)),
      ),
    );
  }

  Future<void> delete(String routineId) async {
    final result = await _deleteRoutine(routineId);
    emit(state.copyWith(failure: result.failureOrNull));
  }

  /// Starts a workout from the routine; returns whether it was started.
  Future<bool> startWorkout(String routineId) async {
    final result = await _startWorkoutFromRoutine(routineId);
    emit(state.copyWith(failure: result.failureOrNull));
    return result.isSuccess;
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
