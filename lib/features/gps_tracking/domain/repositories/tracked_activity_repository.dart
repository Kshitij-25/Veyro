import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/tracked_activity.dart';

abstract interface class TrackedActivityRepository {
  /// Newest first.
  Stream<List<TrackedActivity>> watchActivities();

  /// Activities that started inside [range], oldest first.
  Future<Result<List<TrackedActivity>>> getActivities(DateRange range);

  Future<Result<TrackedActivity>> getActivity(String id);

  Future<Result<void>> saveActivity(TrackedActivity activity);

  Future<Result<void>> deleteActivity(String id);
}
