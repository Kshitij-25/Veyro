import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/entities/body_measurement.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/repositories/body_metrics_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class WatchBodyMeasurements
    implements StreamUseCase<List<BodyMeasurement>, NoParams> {
  const WatchBodyMeasurements(this._repository);

  final BodyMetricsRepository _repository;

  @override
  Stream<List<BodyMeasurement>> call(NoParams params) =>
      _repository.watchMeasurements();
}
