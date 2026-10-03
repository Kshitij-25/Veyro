import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/features/programs/domain/entities/training_plan.dart';
import 'package:fitness_trakcer/features/programs/domain/usecases/program_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'programs_cubit.freezed.dart';

@freezed
abstract class ProgramsState with _$ProgramsState {
  const factory ProgramsState({
    @Default(false) bool loaded,
    @Default(false) bool isBusy,

    /// `null` when not enrolled.
    ProgramProgress? progress,
    Failure? failure,
  }) = _ProgramsState;
}

@injectable
class ProgramsCubit extends Cubit<ProgramsState> {
  ProgramsCubit(
    this._getProgress,
    this._enroll,
    this._leave,
    this._startPlanned,
  ) : super(const ProgramsState());

  final GetProgramProgress _getProgress;
  final EnrollInProgram _enroll;
  final LeaveProgram _leave;
  final StartPlannedWorkout _startPlanned;

  Future<void> load() async {
    final result = await _getProgress(const NoParams());
    if (isClosed) return;
    emit(
      state.copyWith(
        loaded: true,
        progress: result.dataOrNull,
        failure: result.failureOrNull,
      ),
    );
  }

  Future<void> enroll(String programId) async {
    final result = await _enroll(programId);
    emit(state.copyWith(failure: result.failureOrNull));
    await load();
  }

  Future<void> leave() async {
    final result = await _leave(const NoParams());
    emit(state.copyWith(failure: result.failureOrNull));
    await load();
  }

  /// Starts today's session of the active program. True when it began.
  Future<bool> startNextDay() async {
    final progress = state.progress;
    if (progress == null) return false;
    return _start(
      PlannedWorkout(
        progress.program.workoutName(progress.nextDayIndex),
        progress.nextDay.exercises,
      ),
    );
  }

  Future<bool> startSession(QuickSession session) =>
      _start(PlannedWorkout(session.name, session.exercises));

  Future<bool> _start(PlannedWorkout plan) async {
    emit(state.copyWith(isBusy: true, failure: null));
    final result = await _startPlanned(plan);
    emit(state.copyWith(isBusy: false, failure: result.failureOrNull));
    return result.isSuccess;
  }

  void clearFailure() => emit(state.copyWith(failure: null));
}
