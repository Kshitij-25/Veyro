import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/route_point.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/services/location_tracker.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class WatchLocation implements StreamUseCase<RoutePoint, NoParams> {
  const WatchLocation(this._tracker);

  final LocationTracker _tracker;

  @override
  Stream<RoutePoint> call(NoParams params) => _tracker.watchPosition();
}
