import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/repositories/tracked_activity_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DeleteTrackedActivity implements UseCase<void, String> {
  const DeleteTrackedActivity(this._repository);

  final TrackedActivityRepository _repository;

  @override
  Future<Result<void>> call(String params) =>
      _repository.deleteActivity(params);
}
