import 'package:fitness_trakcer/features/gps_tracking/domain/entities/route_point.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/tracking_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tracking_snapshot.freezed.dart';

/// Live numbers of the session that is currently being recorded.
@freezed
abstract class TrackingSnapshot with _$TrackingSnapshot {
  const factory TrackingSnapshot({
    required TrackingStatus status,
    required DateTime startedAt,
    required Duration elapsed,
    @Default(0) double distanceMeters,
    @Default(0) double elevationGainMeters,

    /// Pace over the last ~20 seconds; `null` until enough data is available.
    double? currentPaceSecondsPerKm,
    @Default([]) List<RoutePoint> route,
  }) = _TrackingSnapshot;

  const TrackingSnapshot._();

  RoutePoint? get lastPoint => route.isEmpty ? null : route.last;
}
