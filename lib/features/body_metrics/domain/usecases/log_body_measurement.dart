import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/clock.dart';
import 'package:fitness_trakcer/core/utils/id_generator.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/entities/body_measurement.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/repositories/body_metrics_repository.dart';
import 'package:injectable/injectable.dart';

class LogBodyMeasurementParams {
  const LogBodyMeasurementParams({
    this.measuredAt,
    this.weightKg,
    this.bodyFatPercent,
    this.waistCm,
    this.chestCm,
    this.hipsCm,
    this.armCm,
    this.thighCm,
    this.notes,
  });

  /// Defaults to now.
  final DateTime? measuredAt;
  final double? weightKg;
  final double? bodyFatPercent;
  final double? waistCm;
  final double? chestCm;
  final double? hipsCm;
  final double? armCm;
  final double? thighCm;
  final String? notes;
}

@lazySingleton
class LogBodyMeasurement
    implements UseCase<BodyMeasurement, LogBodyMeasurementParams> {
  const LogBodyMeasurement(this._repository, this._ids, this._clock);

  final BodyMetricsRepository _repository;
  final IdGenerator _ids;
  final Clock _clock;

  @override
  Future<Result<BodyMeasurement>> call(LogBodyMeasurementParams params) async {
    final measurement = BodyMeasurement(
      id: _ids.generate(),
      measuredAt: params.measuredAt ?? _clock.now(),
      weightKg: params.weightKg,
      bodyFatPercent: params.bodyFatPercent,
      waistCm: params.waistCm,
      chestCm: params.chestCm,
      hipsCm: params.hipsCm,
      armCm: params.armCm,
      thighCm: params.thighCm,
      notes: params.notes,
    );
    final failure = measurement.validate();
    if (failure != null) return Fail(failure);
    final saved = await _repository.saveMeasurement(measurement);
    return saved.map((_) => measurement);
  }
}
