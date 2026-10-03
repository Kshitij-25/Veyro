import 'package:fitness_trakcer/features/body_metrics/domain/entities/bmi.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'body_progress.freezed.dart';

@freezed
abstract class WeightPoint with _$WeightPoint {
  const factory WeightPoint({
    required DateTime date,
    required double weightKg,
  }) = _WeightPoint;
}

/// Weight trend over a period, ready to be charted.
@freezed
abstract class BodyProgress with _$BodyProgress {
  const factory BodyProgress({
    /// Oldest first.
    @Default([]) List<WeightPoint> weightPoints,
    double? startWeightKg,
    double? currentWeightKg,
    double? bmi,
  }) = _BodyProgress;

  const BodyProgress._();

  double? get changeKg => (startWeightKg != null && currentWeightKg != null)
      ? currentWeightKg! - startWeightKg!
      : null;

  BmiCategory? get bmiCategory =>
      bmi == null ? null : BmiCategory.fromBmi(bmi!);
}
