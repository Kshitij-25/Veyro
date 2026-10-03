import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/utils/view_status.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'active_workout_state.freezed.dart';

@freezed
abstract class ActiveWorkoutState with _$ActiveWorkoutState {
  const factory ActiveWorkoutState({
    @Default(ViewStatus.initial) ViewStatus status,

    /// The in-progress workout, or `null` when none is running.
    Workout? workout,
    Failure? failure,

    /// A start/finish/discard operation is running.
    @Default(false) bool isBusy,

    /// The workout that was just finished, until acknowledged.
    Workout? finishedWorkout,
  }) = _ActiveWorkoutState;

  const ActiveWorkoutState._();

  bool get hasActiveWorkout => workout != null;
}
