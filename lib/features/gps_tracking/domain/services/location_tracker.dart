import 'package:fitness_trakcer/features/gps_tracking/domain/entities/location_permission_status.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/route_point.dart';

/// Source of GPS fixes (implemented on top of a platform plugin).
abstract interface class LocationTracker {
  Future<LocationPermissionStatus> checkPermission();

  Future<LocationPermissionStatus> requestPermission();

  /// A continuous stream of fixes; the subscription controls tracking.
  Stream<RoutePoint> watchPosition();
}
