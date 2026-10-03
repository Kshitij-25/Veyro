import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/utils/view_status.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout.dart';
import 'package:fitness_trakcer/features/workout/domain/usecases/get_workout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'workout_detail_cubit.freezed.dart';

@freezed
abstract class WorkoutDetailState with _$WorkoutDetailState {
  const factory WorkoutDetailState({
    @Default(ViewStatus.initial) ViewStatus status,
    Workout? workout,
    Failure? failure,
  }) = _WorkoutDetailState;
}

@injectable
class WorkoutDetailCubit extends Cubit<WorkoutDetailState> {
  WorkoutDetailCubit(this._getWorkout) : super(const WorkoutDetailState());

  final GetWorkout _getWorkout;

  Future<void> load(String workoutId) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _getWorkout(workoutId);
    result.when(
      success: (workout) =>
          emit(state.copyWith(status: ViewStatus.success, workout: workout)),
      failure: (failure) =>
          emit(state.copyWith(status: ViewStatus.failure, failure: failure)),
    );
  }
}
