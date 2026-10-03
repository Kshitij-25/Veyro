import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/tracked_activity.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/repositories/tracked_activity_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class WatchTrackedActivities
    implements StreamUseCase<List<TrackedActivity>, NoParams> {
  const WatchTrackedActivities(this._repository);

  final TrackedActivityRepository _repository;

  @override
  Stream<List<TrackedActivity>> call(NoParams params) =>
      _repository.watchActivities();
}
