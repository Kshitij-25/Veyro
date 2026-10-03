import 'package:fitness_trakcer/core/utils/geo.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/route_point.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/tracked_activity_type.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/tracking_snapshot.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/tracking_status.dart';

/// Accumulates GPS fixes into distance, moving time, pace and elevation.
///
/// Pure Dart: the caller feeds it fixes and clock readings. Noisy fixes (poor
/// accuracy, GPS jumps, standing-still jitter) are discarded.
class TrackingSession {
  TrackingSession({required this.type, required DateTime now})
    : startedAt = now,
      _resumedAt = now;

  static const _maxAccuracyMeters = 30.0;
  static const _minSegmentMeters = 1.0;
  static const _elevationThresholdMeters = 3.0;
  static const _paceWindow = Duration(seconds: 20);

  final TrackedActivityType type;
  final DateTime startedAt;

  TrackingStatus _status = TrackingStatus.tracking;
  Duration _accumulated = Duration.zero;
  DateTime? _resumedAt;
  double _distanceMeters = 0;
  double _elevationGainMeters = 0;
  double? _elevationReference;
  final List<RoutePoint> _route = [];
  RoutePoint? _lastPoint;

  TrackingStatus get status => _status;

  Duration elapsed(DateTime now) =>
      _accumulated +
      (_status == TrackingStatus.tracking && _resumedAt != null
          ? now.difference(_resumedAt!)
          : Duration.zero);

  void addPoint(RoutePoint point) {
    if (_status != TrackingStatus.tracking) return;
    final accuracy = point.accuracyMeters;
    if (accuracy != null && accuracy > _maxAccuracyMeters) return;

    final last = _lastPoint;
    if (last != null) {
      final seconds =
          point.timestamp.difference(last.timestamp).inMilliseconds / 1000;
      if (seconds <= 0) return;
      final segment = Geo.distanceMeters(
        last.latitude,
        last.longitude,
        point.latitude,
        point.longitude,
      );
      if (segment < _minSegmentMeters) return;
      if (segment / seconds > type.maxSpeedMetersPerSecond) return;
      _distanceMeters += segment;
    }

    _trackElevation(point.altitudeMeters);
    _route.add(point);
    _lastPoint = point;
  }

  void _trackElevation(double? altitude) {
    if (altitude == null) return;
    final reference = _elevationReference;
    if (reference == null) {
      _elevationReference = altitude;
      return;
    }
    final delta = altitude - reference;
    if (delta >= _elevationThresholdMeters) {
      _elevationGainMeters += delta;
      _elevationReference = altitude;
    } else if (delta <= -_elevationThresholdMeters) {
      _elevationReference = altitude;
    }
  }

  void pause(DateTime now) {
    if (_status != TrackingStatus.tracking) return;
    _accumulated = elapsed(now);
    _resumedAt = null;
    _status = TrackingStatus.paused;
  }

  void resume(DateTime now) {
    if (_status != TrackingStatus.paused) return;
    _resumedAt = now;
    // Avoid counting the distance travelled while paused.
    _lastPoint = null;
    _status = TrackingStatus.tracking;
  }

  /// Stops the session and returns the final numbers.
  TrackingSnapshot finish(DateTime now) {
    final result = snapshot(now);
    _accumulated = result.elapsed;
    _resumedAt = null;
    _status = TrackingStatus.idle;
    return result.copyWith(status: TrackingStatus.idle);
  }

  TrackingSnapshot snapshot(DateTime now) => TrackingSnapshot(
    status: _status,
    startedAt: startedAt,
    elapsed: elapsed(now),
    distanceMeters: _distanceMeters,
    elevationGainMeters: _elevationGainMeters,
    currentPaceSecondsPerKm: _currentPace(),
    route: List.unmodifiable(_route),
  );

  double? _currentPace() {
    if (_route.length < 2) return null;
    final latest = _route.last;
    for (var i = _route.length - 2; i >= 0; i--) {
      final candidate = _route[i];
      final window = latest.timestamp.difference(candidate.timestamp);
      if (window >= _paceWindow) {
        final meters = Geo.distanceMeters(
          candidate.latitude,
          candidate.longitude,
          latest.latitude,
          latest.longitude,
        );
        if (meters < 5) return null;
        return window.inMilliseconds / 1000 / (meters / 1000);
      }
    }
    return null;
  }
}
