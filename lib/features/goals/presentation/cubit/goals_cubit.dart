import 'dart:async';

import 'package:fitness_trakcer/core/error/failure_exception.dart';
import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/view_status.dart';
import 'package:fitness_trakcer/features/goals/domain/entities/goal.dart';
import 'package:fitness_trakcer/features/goals/domain/entities/goal_progress.dart';
import 'package:fitness_trakcer/features/goals/domain/usecases/create_goal.dart';
import 'package:fitness_trakcer/features/goals/domain/usecases/delete_goal.dart';
import 'package:fitness_trakcer/features/goals/domain/usecases/get_goal_progress.dart';
import 'package:fitness_trakcer/features/goals/domain/usecases/watch_goals.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'goals_cubit.freezed.dart';

@freezed
abstract class GoalsState with _$GoalsState {
  const factory GoalsState({
    @Default(ViewStatus.initial) ViewStatus status,
    @Default([]) List<GoalProgress> progress,
    Failure? failure,
  }) = _GoalsState;
}

@injectable
class GoalsCubit extends Cubit<GoalsState> {
  GoalsCubit(
    this._watchGoals,
    this._getGoalProgress,
    this._createGoal,
    this._deleteGoal,
  ) : super(const GoalsState());

  final WatchGoals _watchGoals;
  final GetGoalProgress _getGoalProgress;
  final CreateGoal _createGoal;
  final DeleteGoal _deleteGoal;

  StreamSubscription<List<Goal>>? _subscription;

  /// Recomputes progress whenever the set of goals changes.
  void start() {
    emit(state.copyWith(status: ViewStatus.loading));
    _subscription = _watchGoals(const NoParams()).listen(
      (_) => refresh(),
      onError: (Object error) => emit(
        state.copyWith(status: ViewStatus.failure, failure: toFailure(error)),
      ),
    );
  }

  /// Re-measures all goals against the latest data.
  Future<void> refresh() async {
    final result = await _getGoalProgress(const NoParams());
    if (isClosed) return;
    result.when(
      success: (progress) => emit(
        state.copyWith(
          status: ViewStatus.success,
          progress: progress,
          failure: null,
        ),
      ),
      failure: (failure) =>
          emit(state.copyWith(status: ViewStatus.failure, failure: failure)),
    );
  }

  Future<bool> create(CreateGoalParams params) async {
    final result = await _createGoal(params);
    emit(state.copyWith(failure: result.failureOrNull));
    return result.isSuccess;
  }

  Future<void> delete(String goalId) async {
    final result = await _deleteGoal(goalId);
    emit(state.copyWith(failure: result.failureOrNull));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
