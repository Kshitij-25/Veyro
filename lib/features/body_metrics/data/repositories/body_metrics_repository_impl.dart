import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/activity/data/datasources/health_data_source.dart';
import 'package:fitness_trakcer/features/body_metrics/data/datasources/body_metrics_local_data_source.dart';
import 'package:fitness_trakcer/features/body_metrics/data/mappers/body_measurement_mapper.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/entities/body_measurement.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/repositories/body_metrics_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BodyMetricsRepository)
class BodyMetricsRepositoryImpl implements BodyMetricsRepository {
  const BodyMetricsRepositoryImpl(
    this._localDataSource,
    this._healthDataSource,
  );

  final BodyMetricsLocalDataSource _localDataSource;
  final HealthDataSource _healthDataSource;

  @override
  Stream<List<BodyMeasurement>> watchMeasurements() => _localDataSource
      .watchAll()
      .map((rows) => rows.map((row) => row.toEntity()).toList());

  @override
  Future<Result<List<BodyMeasurement>>> getMeasurements(DateRange range) =>
      guard(() async {
        final rows = await _localDataSource.getRange(range);
        return rows.map((row) => row.toEntity()).toList();
      });

  @override
  Future<Result<BodyMeasurement?>> getLatestWithWeight() => guard(() async {
    final row = await _localDataSource.getLatestWithWeight();
    return row?.toEntity();
  });

  @override
  Future<Result<void>> saveMeasurement(BodyMeasurement measurement) =>
      guard(() => _localDataSource.upsert(measurement.toCompanion()));

  @override
  Future<Result<void>> deleteMeasurement(String id) =>
      guard(() => _localDataSource.delete(id));

  @override
  Future<Result<int>> importFromHealth(DateRange range) => guard(() async {
    final readings = await _healthDataSource.getBodyReadings(range);
    var imported = 0;
    for (final reading in readings) {
      final measurement = BodyMeasurement(
        // Stable id: the same reading overwrites itself on every sync.
        id: 'health-${reading.measuredAt.millisecondsSinceEpoch}',
        measuredAt: reading.measuredAt,
        weightKg: reading.weightKg,
        bodyFatPercent: reading.bodyFatPercent,
        notes: 'Imported from Health',
      );
      if (measurement.validate() != null) continue;
      await _localDataSource.upsert(measurement.toCompanion());
      imported++;
    }
    return imported;
  });
}
