import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/location_permission_status.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/services/location_tracker.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetLocationPermission
    implements UseCase<LocationPermissionStatus, NoParams> {
  const GetLocationPermission(this._tracker);

  final LocationTracker _tracker;

  @override
  Future<Result<LocationPermissionStatus>> call(NoParams params) =>
      guard(_tracker.checkPermission);
}
