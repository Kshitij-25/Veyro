import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:fitness_trakcer/core/database/app_database.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/route_point.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/tracked_activity.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/tracked_activity_type.dart';

String encodeRoute(List<RoutePoint> route) => jsonEncode([
  for (final p in route)
    {
      'lat': p.latitude,
      'lng': p.longitude,
      't': p.timestamp.millisecondsSinceEpoch,
      if (p.altitudeMeters != null) 'alt': p.altitudeMeters,
      if (p.accuracyMeters != null) 'acc': p.accuracyMeters,
    },
]);

List<RoutePoint> decodeRoute(String json) {
  final list = jsonDecode(json) as List<dynamic>;
  return [
    for (final item in list.cast<Map<String, dynamic>>())
      RoutePoint(
        latitude: (item['lat'] as num).toDouble(),
        longitude: (item['lng'] as num).toDouble(),
        timestamp: DateTime.fromMillisecondsSinceEpoch(item['t'] as int),
        altitudeMeters: (item['alt'] as num?)?.toDouble(),
        accuracyMeters: (item['acc'] as num?)?.toDouble(),
      ),
  ];
}

extension TrackedActivityRowMapper on TrackedActivityRow {
  TrackedActivity toEntity() => TrackedActivity(
    id: id,
    type: TrackedActivityType.values.byName(type),
    startedAt: startedAt,
    endedAt: endedAt,
    movingDuration: Duration(seconds: movingSeconds),
    distanceMeters: distanceMeters,
    elevationGainMeters: elevationGainMeters,
    caloriesKcal: caloriesKcal,
    route: decodeRoute(routeJson),
  );
}

extension TrackedActivityEntityMapper on TrackedActivity {
  TrackedActivitiesCompanion toCompanion() => TrackedActivitiesCompanion(
    id: Value(id),
    type: Value(type.name),
    startedAt: Value(startedAt),
    endedAt: Value(endedAt),
    movingSeconds: Value(movingDuration.inSeconds),
    distanceMeters: Value(distanceMeters),
    elevationGainMeters: Value(elevationGainMeters),
    caloriesKcal: Value(caloriesKcal),
    routeJson: Value(encodeRoute(route)),
  );
}
