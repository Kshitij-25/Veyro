import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/entities/body_measurement.dart';

abstract interface class BodyMetricsRepository {
  /// Newest first.
  Stream<List<BodyMeasurement>> watchMeasurements();

  /// Oldest first.
  Future<Result<List<BodyMeasurement>>> getMeasurements(DateRange range);

  Future<Result<BodyMeasurement?>> getLatestWithWeight();

  Future<Result<void>> saveMeasurement(BodyMeasurement measurement);

  Future<Result<void>> deleteMeasurement(String id);
}
