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

  /// Imports weight and body-fat readings from the platform health store.
  /// Re-importing the same reading never creates a duplicate. Returns how
  /// many entries were written.
  Future<Result<int>> importFromHealth(DateRange range);
}
