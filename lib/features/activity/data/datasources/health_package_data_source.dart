import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:fitness_trakcer/features/activity/data/datasources/health_data_source.dart';
import 'package:fitness_trakcer/features/activity/data/models/health_day_summary.dart';
import 'package:fitness_trakcer/features/activity/data/models/health_recovery_day.dart';
import 'package:fitness_trakcer/features/activity/domain/entities/health_access_status.dart';
import 'package:flutter/foundation.dart';
import 'package:health/health.dart';

/// [HealthDataSource] backed by the `health` plugin (iOS and Android).
class HealthPackageDataSource implements HealthDataSource {
  HealthPackageDataSource(this._health);

  final Health _health;

  static const _sleepTypes = [
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.SLEEP_DEEP,
    HealthDataType.SLEEP_LIGHT,
    HealthDataType.SLEEP_REM,
  ];

  /// HRV is SDNN on HealthKit and RMSSD on Health Connect.
  HealthDataType get _hrvType => _isAndroid
      ? HealthDataType.HEART_RATE_VARIABILITY_RMSSD
      : HealthDataType.HEART_RATE_VARIABILITY_SDNN;

  List<HealthDataType> get _types => [
    HealthDataType.STEPS,
    HealthDataType.DISTANCE_DELTA,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    ..._sleepTypes,
    if (_isAndroid) HealthDataType.SLEEP_SESSION,
    _hrvType,
    HealthDataType.RESTING_HEART_RATE,
  ];
  List<HealthDataAccess> get _access =>
      List.filled(_types.length, HealthDataAccess.READ);

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

  @override
  Future<List<HealthRecoveryDay>> getRecoveryDays(DateRange range) async {
    await _ensureConfigured();
    final days = <HealthRecoveryDay>[];
    for (final day in range.days) {
      final dayEnd = DateTime(day.year, day.month, day.day + 1);
      // The night "of" a day is the sleep that ended on it: from 6 pm the
      // evening before to noon.
      final nightStart = DateTime(day.year, day.month, day.day - 1, 18);
      final nightEnd = DateTime(day.year, day.month, day.day, 12);

      final sleepPoints = await _health.getHealthDataFromTypes(
        types: [..._sleepTypes, if (_isAndroid) HealthDataType.SLEEP_SESSION],
        startTime: nightStart,
        endTime: nightEnd,
      );
      var asleep = _unionMinutes(
        sleepPoints.where((p) => _sleepTypes.contains(p.type)),
      );
      if (asleep == 0) {
        asleep = _unionMinutes(
          sleepPoints.where((p) => p.type == HealthDataType.SLEEP_SESSION),
        );
      }

      final points = await _health.getHealthDataFromTypes(
        types: [_hrvType, HealthDataType.RESTING_HEART_RATE],
        startTime: day,
        endTime: dayEnd,
      );
      days.add(
        HealthRecoveryDay(
          date: day,
          sleepMinutes: asleep > 0 ? asleep : null,
          hrvMs: _average(points, _hrvType),
          restingHr: _average(points, HealthDataType.RESTING_HEART_RATE),
        ),
      );
    }
    return days;
  }

  /// Total minutes covered by [points], counting overlaps only once.
  int _unionMinutes(Iterable<HealthDataPoint> points) {
    final spans = [for (final p in points) (p.dateFrom, p.dateTo)]
      ..sort((a, b) => a.$1.compareTo(b.$1));
    var total = Duration.zero;
    DateTime? start;
    DateTime? end;
    for (final (from, to) in spans) {
      if (start == null || end == null || from.isAfter(end)) {
        if (start != null && end != null) total += end.difference(start);
        start = from;
        end = to;
      } else if (to.isAfter(end)) {
        end = to;
      }
    }
    if (start != null && end != null) total += end.difference(start);
    return total.inMinutes;
  }

  double? _average(List<HealthDataPoint> points, HealthDataType type) {
    final values = [
      for (final p in points)
        if (p.type == type && p.value is NumericHealthValue)
          (p.value as NumericHealthValue).numericValue.toDouble(),
    ];
    if (values.isEmpty) return null;
    return values.reduce((a, b) => a + b) / values.length;
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
