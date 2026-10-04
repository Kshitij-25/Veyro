import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:fitness_trakcer/features/activity/data/datasources/health_data_source.dart';
import 'package:fitness_trakcer/features/activity/data/models/health_body_reading.dart';
import 'package:fitness_trakcer/features/activity/data/models/health_day_summary.dart';
import 'package:fitness_trakcer/features/activity/data/models/health_heart_rate_sample.dart';
import 'package:fitness_trakcer/features/activity/data/models/health_recovery_day.dart';
import 'package:fitness_trakcer/features/activity/data/models/health_recovery_record.dart';
import 'package:fitness_trakcer/features/activity/data/models/health_sleep_night.dart';
import 'package:fitness_trakcer/features/activity/data/models/health_workout.dart';
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
    HealthDataType.SLEEP_AWAKE,
    HealthDataType.SLEEP_IN_BED,
  ];

  /// HRV is SDNN on HealthKit and RMSSD on Health Connect.
  HealthDataType get _hrvType => _isAndroid
      ? HealthDataType.HEART_RATE_VARIABILITY_RMSSD
      : HealthDataType.HEART_RATE_VARIABILITY_SDNN;

  bool _supportedSleep(HealthDataType t) =>
      !_isAndroid || t != HealthDataType.SLEEP_IN_BED;

  /// DISTANCE_DELTA only exists on Health Connect; HealthKit has its own.
  HealthDataType get _distanceType => _isAndroid
      ? HealthDataType.DISTANCE_DELTA
      : HealthDataType.DISTANCE_WALKING_RUNNING;

  static const _asleepTypes = [
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.SLEEP_DEEP,
    HealthDataType.SLEEP_LIGHT,
    HealthDataType.SLEEP_REM,
  ];

  List<HealthDataType> get _types => [
    HealthDataType.STEPS,
    _distanceType,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    ..._sleepTypes.where(_supportedSleep),
    if (_isAndroid) HealthDataType.SLEEP_SESSION,
    _hrvType,
    HealthDataType.RESTING_HEART_RATE,
    HealthDataType.WEIGHT,
    HealthDataType.BODY_FAT_PERCENTAGE,
    HealthDataType.HEART_RATE,
    HealthDataType.WORKOUT,
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
    // One bulk read for distance and energy, then split by day. Steps need
    // the platform's de-duplicating total, so those stay one call per day.
    final points = await _health.getHealthDataFromTypes(
      types: [_distanceType, HealthDataType.ACTIVE_ENERGY_BURNED],
      startTime: range.start,
      endTime: range.end,
    );
    // iPhone and Watch both record walking distance for the same minutes:
    // total each source per day and keep the fullest one, not the sum.
    final distanceBySource = <DateTime, Map<String, double>>{};
    final energyBySource = <DateTime, Map<String, double>>{};
    for (final p in points) {
      final value = p.value;
      if (value is! NumericHealthValue) continue;
      final day = DateTime(p.dateFrom.year, p.dateFrom.month, p.dateFrom.day);
      final amount = value.numericValue.toDouble();
      final bucket = p.type == _distanceType
          ? distanceBySource
          : p.type == HealthDataType.ACTIVE_ENERGY_BURNED
          ? energyBySource
          : null;
      if (bucket == null) continue;
      final sources = bucket[day] ??= {};
      sources[p.sourceId] = (sources[p.sourceId] ?? 0) + amount;
    }
    double fullest(Map<String, double>? sources) =>
        sources == null || sources.isEmpty
        ? 0
        : sources.values.reduce((a, b) => a > b ? a : b);
    final distance = {
      for (final e in distanceBySource.entries) e.key: fullest(e.value),
    };
    final energy = {
      for (final e in energyBySource.entries) e.key: fullest(e.value),
    };
    final summaries = <HealthDaySummary>[];
    for (final day in range.days) {
      final dayEnd = DateTime(day.year, day.month, day.day + 1);
      final steps = await _health.getTotalStepsInInterval(day, dayEnd) ?? 0;
      summaries.add(
        HealthDaySummary(
          date: day,
          steps: steps,
          distanceMeters: distance[day] ?? 0,
          activeCaloriesKcal: energy[day] ?? 0,
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
        types: [
          ..._sleepTypes.where(_supportedSleep),
          if (_isAndroid) HealthDataType.SLEEP_SESSION,
        ],
        startTime: nightStart,
        endTime: nightEnd,
      );
      var asleep = _unionMinutes(
        sleepPoints.where((p) => _asleepTypes.contains(p.type)),
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

  @override
  Future<List<HealthSleepNight>> getSleepNights(DateRange range) async {
    await _ensureConfigured();
    final nights = <HealthSleepNight>[];
    for (final day in range.days) {
      final from = DateTime(day.year, day.month, day.day - 1, 18);
      final to = DateTime(day.year, day.month, day.day, 12);
      final points = await _health.getHealthDataFromTypes(
        types: [
          ..._sleepTypes.where(_supportedSleep),
          if (_isAndroid) HealthDataType.SLEEP_SESSION,
        ],
        startTime: from,
        endTime: to,
      );

      HealthSleepSegment seg(HealthDataPoint p, HealthSleepStage s) =>
          HealthSleepSegment(stage: s, start: p.dateFrom, end: p.dateTo);
      final staged = <HealthSleepSegment>[];
      final plain = <HealthSleepSegment>[];
      final session = <HealthSleepSegment>[];
      final inBed = <HealthDataPoint>[];
      for (final p in points) {
        switch (p.type) {
          case HealthDataType.SLEEP_AWAKE:
            staged.add(seg(p, HealthSleepStage.awake));
          case HealthDataType.SLEEP_REM:
            staged.add(seg(p, HealthSleepStage.rem));
          case HealthDataType.SLEEP_LIGHT:
            staged.add(seg(p, HealthSleepStage.light));
          case HealthDataType.SLEEP_DEEP:
            staged.add(seg(p, HealthSleepStage.deep));
          case HealthDataType.SLEEP_ASLEEP:
            plain.add(seg(p, HealthSleepStage.asleep));
          case HealthDataType.SLEEP_SESSION:
            session.add(seg(p, HealthSleepStage.asleep));
          case HealthDataType.SLEEP_IN_BED:
            inBed.add(p);
          default:
        }
      }
      // Several sources can cover the same time: prefer detailed stages,
      // then unstaged sleep, then the session.
      final chosen = staged.isNotEmpty
          ? staged
          : plain.isNotEmpty
          ? plain
          : session;
      if (chosen.isEmpty) continue;
      chosen.sort((a, b) => a.start.compareTo(b.start));
      final segments = <HealthSleepSegment>[];
      for (final s in chosen) {
        final last = segments.isEmpty ? null : segments.last;
        if (last != null && s.start.isBefore(last.end)) {
          if (!s.end.isAfter(last.end)) continue;
          segments.add(
            HealthSleepSegment(stage: s.stage, start: last.end, end: s.end),
          );
        } else {
          segments.add(s);
        }
      }

      final hrPoints = await _health.getHealthDataFromTypes(
        types: const [HealthDataType.HEART_RATE],
        startTime: segments.first.start,
        endTime: segments.last.end,
      );
      inBed.sort((a, b) => a.dateFrom.compareTo(b.dateFrom));
      nights.add(
        HealthSleepNight(
          date: day,
          segments: segments,
          inBedStart: inBed.isEmpty ? null : inBed.first.dateFrom,
          inBedEnd: inBed.isEmpty
              ? null
              : inBed
                    .map((p) => p.dateTo)
                    .reduce((a, b) => a.isAfter(b) ? a : b),
          sleepingHr: _average(hrPoints, HealthDataType.HEART_RATE),
        ),
      );
    }
    return nights;
  }

  @override
  Future<List<HealthHeartRateSample>> getHeartRateSamples(
    DateRange range,
  ) async {
    await _ensureConfigured();
    final points = await _health.getHealthDataFromTypes(
      types: const [HealthDataType.HEART_RATE],
      startTime: range.start,
      endTime: range.end,
    );
    final samples = [
      for (final p in points)
        if (p.value is NumericHealthValue)
          HealthHeartRateSample(
            time: p.dateFrom,
            bpm: (p.value as NumericHealthValue).numericValue.toDouble(),
          ),
    ]..sort((a, b) => a.time.compareTo(b.time));
    return samples;
  }

  @override
  Future<List<HealthWorkout>> getWorkouts(DateRange range) async {
    await _ensureConfigured();
    final points = await _health.getHealthDataFromTypes(
      types: const [HealthDataType.WORKOUT],
      startTime: range.start,
      endTime: range.end,
    );
    final workouts = <HealthWorkout>[];
    for (final p in points) {
      final summary = p.workoutSummary;
      if (summary == null) continue;
      final kind = _workoutKind(summary.workoutType);
      workouts.add(
        HealthWorkout(
          uuid: p.uuid.isNotEmpty
              ? p.uuid
              : '${p.dateFrom.millisecondsSinceEpoch}',
          kind: kind,
          title: _workoutTitle(summary.workoutType),
          start: p.dateFrom,
          end: p.dateTo,
          distanceMeters: summary.totalDistance.toDouble(),
          caloriesKcal: summary.totalEnergyBurned.toDouble(),
          source: p.sourceName.trim().isEmpty
              ? null
              : _friendlySource(p.sourceName),
        ),
      );
    }
    workouts.sort((a, b) => a.start.compareTo(b.start));
    return workouts;
  }

  static String _workoutKind(String type) {
    final t = type.toUpperCase();
    if (t.startsWith('RUNNING')) return 'run';
    if (t.startsWith('WALKING') || t == 'HIKING') return 'walk';
    if (t.startsWith('BIKING') || t == 'CYCLING') return 'cycle';
    return 'other';
  }

  static String _workoutTitle(String type) {
    final words = type
        .toLowerCase()
        .split('_')
        .where((w) => w.isNotEmpty)
        .toList();
    if (words.isEmpty) return 'Workout';
    final text = words.join(' ');
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }

  @override
  Future<List<HealthRecoveryRecord>> getRecoveryHistory(DateRange range) async {
    await _ensureConfigured();
    // A night belongs to the day it ends on: 6 pm the evening before to noon.
    final sleepPoints = await _health.getHealthDataFromTypes(
      types: [
        ..._sleepTypes.where(_supportedSleep),
        if (_isAndroid) HealthDataType.SLEEP_SESSION,
      ],
      startTime: range.start.subtract(const Duration(hours: 6)),
      endTime: range.end,
    );
    final byNight = <DateTime, List<HealthDataPoint>>{};
    for (final p in sleepPoints) {
      final mid = p.dateFrom.add(p.dateTo.difference(p.dateFrom) ~/ 2);
      if (mid.hour >= 12 && mid.hour < 18) continue; // daytime nap
      final night = mid.hour >= 18
          ? DateTime(mid.year, mid.month, mid.day + 1)
          : DateTime(mid.year, mid.month, mid.day);
      if (night.isBefore(range.start) || !night.isBefore(range.end)) continue;
      byNight.putIfAbsent(night, () => []).add(p);
    }

    final vitals = await _health.getHealthDataFromTypes(
      types: [_hrvType, HealthDataType.RESTING_HEART_RATE],
      startTime: range.start,
      endTime: range.end,
    );
    final byDay = <DateTime, List<HealthDataPoint>>{};
    for (final p in vitals) {
      final day = DateTime(p.dateFrom.year, p.dateFrom.month, p.dateFrom.day);
      byDay.putIfAbsent(day, () => []).add(p);
    }

    final records = <HealthRecoveryRecord>[];
    for (final day in {...byNight.keys, ...byDay.keys}) {
      final segments = _mergeSleep(byNight[day] ?? const []);
      int minutes(bool Function(HealthSleepStage) test) => segments
          .where((s) => test(s.stage))
          .fold(0, (a, s) => a + s.end.difference(s.start).inMinutes);
      final asleep = minutes((s) => s != HealthSleepStage.awake);
      final vitals = byDay[day] ?? const [];
      records.add(
        HealthRecoveryRecord(
          date: day,
          asleepMinutes: asleep > 0 ? asleep : null,
          awakeMinutes: segments.isEmpty
              ? null
              : minutes((s) => s == HealthSleepStage.awake),
          remMinutes: segments.isEmpty
              ? null
              : minutes((s) => s == HealthSleepStage.rem),
          lightMinutes: segments.isEmpty
              ? null
              : minutes((s) => s == HealthSleepStage.light),
          deepMinutes: segments.isEmpty
              ? null
              : minutes((s) => s == HealthSleepStage.deep),
          bedtime: segments.isEmpty ? null : segments.first.start,
          wakeTime: segments.isEmpty ? null : segments.last.end,
          hrvMs: _average(vitals, _hrvType),
          restingHr: _average(vitals, HealthDataType.RESTING_HEART_RATE),
        ),
      );
    }
    records.sort((a, b) => a.date.compareTo(b.date));
    return records.where((r) => r.hasData).toList();
  }

  /// Picks the most detailed sleep data (stages, then plain sleep, then the
  /// session) and removes overlaps between sources.
  List<HealthSleepSegment> _mergeSleep(List<HealthDataPoint> points) {
    HealthSleepSegment seg(HealthDataPoint p, HealthSleepStage s) =>
        HealthSleepSegment(stage: s, start: p.dateFrom, end: p.dateTo);
    final staged = <HealthSleepSegment>[];
    final plain = <HealthSleepSegment>[];
    final session = <HealthSleepSegment>[];
    for (final p in points) {
      switch (p.type) {
        case HealthDataType.SLEEP_AWAKE:
          staged.add(seg(p, HealthSleepStage.awake));
        case HealthDataType.SLEEP_REM:
          staged.add(seg(p, HealthSleepStage.rem));
        case HealthDataType.SLEEP_LIGHT:
          staged.add(seg(p, HealthSleepStage.light));
        case HealthDataType.SLEEP_DEEP:
          staged.add(seg(p, HealthSleepStage.deep));
        case HealthDataType.SLEEP_ASLEEP:
          plain.add(seg(p, HealthSleepStage.asleep));
        case HealthDataType.SLEEP_SESSION:
          session.add(seg(p, HealthSleepStage.asleep));
        default:
      }
    }
    final chosen = staged.isNotEmpty
        ? staged
        : plain.isNotEmpty
        ? plain
        : session;
    chosen.sort((a, b) => a.start.compareTo(b.start));
    final merged = <HealthSleepSegment>[];
    for (final s in chosen) {
      final last = merged.isEmpty ? null : merged.last;
      if (last != null && s.start.isBefore(last.end)) {
        if (!s.end.isAfter(last.end)) continue;
        merged.add(
          HealthSleepSegment(stage: s.stage, start: last.end, end: s.end),
        );
      } else {
        merged.add(s);
      }
    }
    return merged;
  }

  @override
  Future<bool> requestHistoryAccess() async {
    if (!_isAndroid) return true; // HealthKit has no 30-day limit.
    await _ensureConfigured();
    if (!await _health.isHealthDataHistoryAvailable()) return false;
    if (await _health.isHealthDataHistoryAuthorized()) return true;
    return _health.requestHealthDataHistoryAuthorization();
  }

  @override
  Future<List<HealthBodyReading>> getBodyReadings(DateRange range) async {
    await _ensureConfigured();
    final points = await _health.getHealthDataFromTypes(
      types: const [HealthDataType.WEIGHT, HealthDataType.BODY_FAT_PERCENTAGE],
      startTime: range.start,
      endTime: range.end,
    );
    final weights = <DateTime, double>{};
    final fats = <DateTime, double>{};
    for (final p in points) {
      final value = p.value;
      if (value is! NumericHealthValue) continue;
      final number = value.numericValue.toDouble();
      final at = p.dateFrom;
      if (p.type == HealthDataType.WEIGHT) {
        weights[at] = number;
      } else if (p.type == HealthDataType.BODY_FAT_PERCENTAGE) {
        // HealthKit reports a 0..1 fraction, Health Connect a percentage.
        fats[at] = number <= 1 ? number * 100 : number;
      }
    }

    // Smart scales usually write weight and fat a moment apart; join them.
    final readings = <HealthBodyReading>[];
    final unpairedFat = Map.of(fats);
    for (final entry in weights.entries) {
      DateTime? match;
      for (final at in unpairedFat.keys) {
        if (at.difference(entry.key).abs() <= const Duration(hours: 6) &&
            (match == null ||
                at.difference(entry.key).abs() <
                    match.difference(entry.key).abs())) {
          match = at;
        }
      }
      readings.add(
        HealthBodyReading(
          measuredAt: entry.key,
          weightKg: entry.value,
          bodyFatPercent: match == null ? null : unpairedFat.remove(match),
        ),
      );
    }
    for (final entry in unpairedFat.entries) {
      readings.add(
        HealthBodyReading(measuredAt: entry.key, bodyFatPercent: entry.value),
      );
    }
    readings.sort((a, b) => a.measuredAt.compareTo(b.measuredAt));
    return readings;
  }

  @override
  Future<List<String>> getSourceNames(DateRange range) async {
    await _ensureConfigured();
    final points = await _health.getHealthDataFromTypes(
      types: const [
        HealthDataType.STEPS,
        HealthDataType.ACTIVE_ENERGY_BURNED,
        HealthDataType.WEIGHT,
      ],
      startTime: range.start,
      endTime: range.end,
    );
    final names = <String>{
      for (final p in points)
        if (p.sourceName.trim().isNotEmpty) _friendlySource(p.sourceName),
    };
    return names.toList()..sort();
  }

  @override
  Future<void> installProvider() async {
    if (_isAndroid) await _health.installHealthConnect();
  }

  /// Health Connect reports package names; show the app's real name.
  static String _friendlySource(String raw) {
    const known = {
      'com.sec.android.app.shealth': 'Samsung Health',
      'com.samsung.android.shealthmonitor': 'Samsung Health Monitor',
      'com.google.android.apps.fitness': 'Google Fit',
      'com.google.android.apps.healthdata': 'Health Connect',
      'com.fitbit.FitbitMobile': 'Fitbit',
      'com.garmin.android.apps.connectmobile': 'Garmin Connect',
      'com.ouraring.oura': 'Oura',
      'com.withings.wiscale2': 'Withings',
      'com.xiaomi.hm.health': 'Zepp',
      'com.huawei.health': 'Huawei Health',
      'com.strava': 'Strava',
      'com.whoop.android': 'WHOOP',
    };
    return known[raw] ?? raw;
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
}
