import 'package:freezed_annotation/freezed_annotation.dart';

part 'route_point.freezed.dart';

/// One GPS fix along a recorded route.
@freezed
abstract class RoutePoint with _$RoutePoint {
  const factory RoutePoint({
    required double latitude,
    required double longitude,
    required DateTime timestamp,
    double? altitudeMeters,
    double? accuracyMeters,
  }) = _RoutePoint;
}
