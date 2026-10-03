import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/activity/domain/entities/health_access_status.dart';
import 'package:fitness_trakcer/features/activity/domain/repositories/activity_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetHealthAccessStatus implements UseCase<HealthAccessStatus, NoParams> {
  const GetHealthAccessStatus(this._repository);

  final ActivityRepository _repository;

  @override
  Future<Result<HealthAccessStatus>> call(NoParams params) =>
      _repository.getHealthAccessStatus();
}
