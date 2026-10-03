import 'package:fitness_trakcer/features/gps_tracking/domain/entities/location_permission_status.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/route_point.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/services/location_tracker.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

/// [LocationTracker] backed by the `geolocator` plugin.
class GeolocatorLocationTracker implements LocationTracker {
  const GeolocatorLocationTracker();

  @override
  Future<LocationPermissionStatus> checkPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return LocationPermissionStatus.serviceDisabled;
    }
    return _map(await Geolocator.checkPermission());
  }

  @override
  Future<LocationPermissionStatus> requestPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return LocationPermissionStatus.serviceDisabled;
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return _map(permission);
  }

  LocationPermissionStatus _map(LocationPermission permission) =>
      switch (permission) {
        LocationPermission.always ||
        LocationPermission.whileInUse => LocationPermissionStatus.granted,
        LocationPermission.deniedForever =>
          LocationPermissionStatus.deniedForever,
        LocationPermission.denied ||
        LocationPermission.unableToDetermine => LocationPermissionStatus.denied,
      };

  @override
  Stream<RoutePoint> watchPosition() =>
      Geolocator.getPositionStream(locationSettings: _settings()).map(
        (position) => RoutePoint(
          latitude: position.latitude,
          longitude: position.longitude,
          timestamp: position.timestamp,
          altitudeMeters: position.altitude,
          accuracyMeters: position.accuracy,
        ),
      );

  LocationSettings _settings() {
    if (kIsWeb) {
      return const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      );
    }
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
        intervalDuration: const Duration(seconds: 2),
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationTitle: 'Recording activity',
          notificationText: 'Your route is being tracked.',
          enableWakeLock: true,
          setOngoing: true,
        ),
      ),
      TargetPlatform.iOS || TargetPlatform.macOS => AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 5,
        pauseLocationUpdatesAutomatically: false,
        showBackgroundLocationIndicator: true,
      ),
      _ => const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    };
  }
}
