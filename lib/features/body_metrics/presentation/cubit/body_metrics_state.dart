import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/utils/view_status.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/entities/body_measurement.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/entities/body_progress.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'body_metrics_state.freezed.dart';

@freezed
abstract class BodyMetricsState with _$BodyMetricsState {
  const factory BodyMetricsState({
    @Default(ViewStatus.initial) ViewStatus status,

    /// Newest first.
    @Default([]) List<BodyMeasurement> measurements,
    @Default(BodyProgress()) BodyProgress progress,

    /// Number of days the progress/trend covers.
    @Default(90) int progressDays,
    Failure? failure,
  }) = _BodyMetricsState;
}
