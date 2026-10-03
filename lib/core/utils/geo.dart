import 'dart:math' as math;

abstract final class Geo {
  static const _earthRadiusMeters = 6371008.8;

  /// Great-circle distance between two coordinates (haversine formula).
  static double distanceMeters(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    final dLat = _radians(lat2 - lat1);
    final dLon = _radians(lon2 - lon1);
    final a =
        math.pow(math.sin(dLat / 2), 2) +
        math.cos(_radians(lat1)) *
            math.cos(_radians(lat2)) *
            math.pow(math.sin(dLon / 2), 2);
    return 2 * _earthRadiusMeters * math.asin(math.sqrt(a));
  }

  static double _radians(double degrees) => degrees * math.pi / 180;
}
