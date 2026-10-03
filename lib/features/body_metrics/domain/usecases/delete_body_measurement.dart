import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/repositories/body_metrics_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DeleteBodyMeasurement implements UseCase<void, String> {
  const DeleteBodyMeasurement(this._repository);

  final BodyMetricsRepository _repository;

  @override
  Future<Result<void>> call(String params) =>
      _repository.deleteMeasurement(params);
}
