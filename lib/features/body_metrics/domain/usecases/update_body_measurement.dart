import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/entities/body_measurement.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/repositories/body_metrics_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UpdateBodyMeasurement implements UseCase<void, BodyMeasurement> {
  const UpdateBodyMeasurement(this._repository);

  final BodyMetricsRepository _repository;

  @override
  Future<Result<void>> call(BodyMeasurement params) async {
    final failure = params.validate();
    if (failure != null) return Fail(failure);
    return _repository.saveMeasurement(params);
  }
}
