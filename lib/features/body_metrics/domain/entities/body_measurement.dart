import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'body_measurement.freezed.dart';

/// A dated snapshot of body metrics. Every value is optional so a user can
/// log just their weight or just a waist measurement.
@freezed
abstract class BodyMeasurement with _$BodyMeasurement {
  const factory BodyMeasurement({
    required String id,
    required DateTime measuredAt,
    double? weightKg,
    double? bodyFatPercent,
    double? waistCm,
    double? chestCm,
    double? hipsCm,
    double? armCm,
    double? thighCm,
    String? notes,
  }) = _BodyMeasurement;

  const BodyMeasurement._();

  bool get hasAnyValue =>
      weightKg != null ||
      bodyFatPercent != null ||
      waistCm != null ||
      chestCm != null ||
      hipsCm != null ||
      armCm != null ||
      thighCm != null;

  /// Returns a [ValidationFailure] when the values are not plausible.
  Failure? validate() {
    if (!hasAnyValue) {
      return const ValidationFailure('Enter at least one measurement.');
    }
    if (weightKg != null && (weightKg! < 20 || weightKg! > 500)) {
      return const ValidationFailure('Weight must be between 20 and 500 kg.');
    }
    if (bodyFatPercent != null &&
        (bodyFatPercent! < 2 || bodyFatPercent! > 70)) {
      return const ValidationFailure('Body fat must be between 2% and 70%.');
    }
    final lengths = [waistCm, chestCm, hipsCm, armCm, thighCm];
    if (lengths.any((v) => v != null && (v <= 0 || v > 300))) {
      return const ValidationFailure(
        'Measurements must be between 0 and 300 cm.',
      );
    }
    return null;
  }
}
