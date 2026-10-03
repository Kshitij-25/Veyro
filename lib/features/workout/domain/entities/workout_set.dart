import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_set.freezed.dart';

@freezed
abstract class WorkoutSet with _$WorkoutSet {
  const factory WorkoutSet({
    required String id,
    required int position,
    int? reps,
    double? weightKg,
    int? durationSeconds,
    double? distanceMeters,
    @Default(false) bool isWarmup,
    @Default(false) bool isCompleted,
  }) = _WorkoutSet;

  const WorkoutSet._();

  /// Weight × reps for completed working sets; warm-ups don't count.
  double get volumeKg =>
      (isCompleted && !isWarmup) ? (weightKg ?? 0) * (reps ?? 0) : 0;
}
