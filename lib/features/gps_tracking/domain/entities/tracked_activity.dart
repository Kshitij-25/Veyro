import 'package:fitness_trakcer/features/gps_tracking/domain/entities/route_point.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/tracked_activity_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tracked_activity.freezed.dart';

@freezed
abstract class TrackedActivity with _$TrackedActivity {
  const factory TrackedActivity({
    required String id,
    required TrackedActivityType type,
    String? title,
    required DateTime startedAt,
    required DateTime endedAt,
    required Duration movingDuration,
    required double distanceMeters,
    @Default(0) double elevationGainMeters,
    @Default(0) double caloriesKcal,
    @Default([]) List<RoutePoint> route,
  }) = _TrackedActivity;

  const TrackedActivity._();

  /// A Health-imported gym-style session (functional or traditional strength,
  /// core, HIIT...). Used where a lifting session is expected but the Watch
  /// supplies no exercises.
  bool get isStrengthSession {
    if (type != TrackedActivityType.other) return false;
    final t = displayName.toLowerCase();
    return const [
      'strength',
      'weight',
      'resistance',
      'calisthenic',
      'core',
      'hiit',
      'high intensity',
      'cross',
      'circuit',
      'bootcamp',
    ].any(t.contains);
  }

  /// What to call it: the imported name, or the activity type.
  String get displayName => title ?? type.label;

  double get averageSpeedKmh => movingDuration.inSeconds == 0
      ? 0
      : (distanceMeters / 1000) / (movingDuration.inSeconds / 3600);

  /// Seconds per kilometre; `0` when no distance was covered.
  double get averagePaceSecondsPerKm => distanceMeters <= 0
      ? 0
      : movingDuration.inSeconds / (distanceMeters / 1000);
}
