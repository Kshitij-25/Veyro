import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:fitness_trakcer/features/activity/data/datasources/health_data_source.dart';
import 'package:fitness_trakcer/features/activity/data/models/health_day_summary.dart';
import 'package:fitness_trakcer/features/activity/domain/entities/health_access_status.dart';
import 'package:flutter/foundation.dart';
import 'package:health/health.dart';

/// [HealthDataSource] backed by the `health` plugin (iOS and Android).
class HealthPackageDataSource implements HealthDataSource {
  HealthPackageDataSource(this._health);

  final Health _health;

  static const _types = [
    HealthDataType.STEPS,
    HealthDataType.DISTANCE_DELTA,
    HealthDataType.ACTIVE_ENERGY_BURNED,
  ];
  static final _access = List.filled(_types.length, HealthDataAccess.READ);

  bool _configured = false;

  bool get _isAndroid => defaultTargetPlatform == TargetPlatform.android;

  Future<void> _ensureConfigured() async {
    if (_configured) return;
    await _health.configure();
    _configured = true;
  }

  @override
  Future<HealthAccessStatus> getAccessStatus() async {
    await _ensureConfigured();
    if (_isAndroid && !await _health.isHealthConnectAvailable()) {
      return HealthAccessStatus.unavailable;
    }
    final granted = await _health.hasPermissions(_types, permissions: _access);
    return switch (granted) {
      true => HealthAccessStatus.granted,
      false => HealthAccessStatus.notGranted,
      null => HealthAccessStatus.unknown,
    };
  }

  @override
  Future<HealthAccessStatus> requestAccess() async {
    await _ensureConfigured();
    if (_isAndroid && !await _health.isHealthConnectAvailable()) {
      return HealthAccessStatus.unavailable;
    }
    final granted = await _health.requestAuthorization(
      _types,
      permissions: _access,
    );
    return granted ? HealthAccessStatus.granted : HealthAccessStatus.notGranted;
  }

  @override
  Future<List<HealthDaySummary>> getDailySummaries(DateRange range) async {
    await _ensureConfigured();
    final summaries = <HealthDaySummary>[];
    for (final day in range.days) {
      final dayEnd = DateTime(day.year, day.month, day.day + 1);
      final steps = await _health.getTotalStepsInInterval(day, dayEnd) ?? 0;
      final points = await _health.getHealthDataFromTypes(
        types: const [
          HealthDataType.DISTANCE_DELTA,
          HealthDataType.ACTIVE_ENERGY_BURNED,
        ],
        startTime: day,
        endTime: dayEnd,
      );
      summaries.add(
        HealthDaySummary(
          date: day,
          steps: steps,
          distanceMeters: _sum(points, HealthDataType.DISTANCE_DELTA),
          activeCaloriesKcal: _sum(points, HealthDataType.ACTIVE_ENERGY_BURNED),
        ),
      );
    }
    return summaries;
  }

  double _sum(List<HealthDataPoint> points, HealthDataType type) {
    var total = 0.0;
    for (final point in points) {
      final value = point.value;
      if (point.type == type && value is NumericHealthValue) {
        total += value.numericValue.toDouble();
      }
    }
    return total;
  }
}
