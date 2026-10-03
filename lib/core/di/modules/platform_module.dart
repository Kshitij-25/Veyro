import 'package:fitness_trakcer/features/activity/data/datasources/health_data_source.dart';
import 'package:fitness_trakcer/features/activity/data/datasources/health_package_data_source.dart';
import 'package:fitness_trakcer/features/activity/data/datasources/unavailable_health_data_source.dart';
import 'package:fitness_trakcer/features/gps_tracking/data/services/geolocator_location_tracker.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/services/location_tracker.dart';
import 'package:fitness_trakcer/features/reminders/data/services/local_notification_reminder_scheduler.dart';
import 'package:fitness_trakcer/features/reminders/data/services/unsupported_reminder_scheduler.dart';
import 'package:fitness_trakcer/features/reminders/domain/services/reminder_scheduler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:health/health.dart';
import 'package:injectable/injectable.dart';

/// Wires platform plugins, falling back to inert implementations on
/// platforms where a plugin has no support.
@module
abstract class PlatformModule {
  @lazySingleton
  HealthDataSource get healthDataSource => _supportsHealth
      ? HealthPackageDataSource(Health())
      : const UnavailableHealthDataSource();

  @lazySingleton
  LocationTracker get locationTracker => const GeolocatorLocationTracker();

  @lazySingleton
  ReminderScheduler get reminderScheduler => _supportsNotifications
      ? LocalNotificationReminderScheduler(FlutterLocalNotificationsPlugin())
      : const UnsupportedReminderScheduler();
}

bool get _supportsHealth =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS);

bool get _supportsNotifications =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS);
