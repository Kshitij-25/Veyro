import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/tracked_activity.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/repositories/tracked_activity_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetTrackedActivity implements UseCase<TrackedActivity, String> {
  const GetTrackedActivity(this._repository);

  final TrackedActivityRepository _repository;

  @override
  Future<Result<TrackedActivity>> call(String params) =>
      _repository.getActivity(params);
}
