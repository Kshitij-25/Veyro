import 'package:drift/drift.dart' show Value;
import 'package:fitness_trakcer/core/database/app_database.dart';
import 'package:fitness_trakcer/core/utils/clock.dart';
import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/activity/data/datasources/health_data_source.dart';
import 'package:fitness_trakcer/features/activity/domain/repositories/activity_repository.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/repositories/body_metrics_repository.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/repositories/tracked_activity_repository.dart';
import 'package:fitness_trakcer/features/health_sync/data/datasources/recovery_history_local_data_source.dart';
import 'package:fitness_trakcer/features/health_sync/domain/entities/health_history.dart';
import 'package:fitness_trakcer/features/health_sync/domain/entities/health_sync_report.dart';
import 'package:fitness_trakcer/features/health_sync/domain/repositories/health_sync_repository.dart';
import 'package:fitness_trakcer/features/wellness/data/datasources/wellness_local_data_source.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: HealthSyncRepository)
class HealthSyncRepositoryImpl implements HealthSyncRepository {
  const HealthSyncRepositoryImpl(
    this._activity,
    this._body,
    this._tracked,
    this._recovery,
    this._health,
    this._settings,
    this._clock,
  );

  static const _lastSyncKey = 'health_last_sync';
  static const _connectedKey = 'health_connected';
  static const _historyOldestKey = 'health_history_oldest';
  static const _historyDoneKey = 'health_history_done';

  /// Months with no data in a row that mean "we've reached the start".
  static const _gapAfterData = 12;
  static const _gapBeforeAnyData = 60;
  static const _maxMonths = 360;

  final ActivityRepository _activity;
  final BodyMetricsRepository _body;
  final TrackedActivityRepository _tracked;
  final RecoveryHistoryLocalDataSource _recovery;
  final HealthDataSource _health;
  final WellnessLocalDataSource _settings;
  final Clock _clock;

  @override
  Future<Result<HealthSyncReport>> sync({required int days}) => guard(() async {
    final range = DateRange.lastDays(days, until: _clock.now());
    (await _activity.syncFromHealth(range)).getOrThrow();
    final bodyEntries = (await _body.importFromHealth(range)).getOrThrow();
    // Workouts need their own permission; without it the rest still syncs.
    final workouts = (await _tracked.importFromHealth(range)).dataOrNull ?? 0;
    // Naming the sources is cosmetic; a failure here must not fail the sync.
    final sources = await _health
        .getSourceNames(range)
        .catchError((_) => <String>[]);
    final now = _clock.now();
    await _settings.setSetting(_lastSyncKey, now.toIso8601String());
    return HealthSyncReport(
      syncedAt: now,
      activityDays: range.days.length,
      bodyEntries: bodyEntries,
      workouts: workouts,
      sources: sources,
    );
  });

  @override
  Future<DateTime?> getLastSync() async {
    final raw = await _settings.getSetting(_lastSyncKey);
    return raw == null ? null : DateTime.tryParse(raw);
  }

  @override
  Future<bool> wasConnected() async =>
      await _settings.getSetting(_connectedKey) == '1';

  @override
  Future<void> markConnected() => _settings.setSetting(_connectedKey, '1');

  @override
  Future<Result<void>> installProvider() => guard(_health.installProvider);

  @override
  Future<Result<HealthHistoryReport>> importHistory({
    required void Function(HealthHistoryProgress progress) onProgress,
    required bool Function() isCancelled,
  }) => guard(() async {
    await _health.requestHistoryAccess();
    final now = _clock.now();
    var month = DateTime(now.year, now.month);
    var progress = HealthHistoryProgress(month: month);
    DateTime? oldest;
    var emptyStreak = 0;
    var foundAny = false;

    for (var i = 0; i < _maxMonths; i++) {
      if (isCancelled()) {
        return HealthHistoryReport(
          progress: progress,
          oldest: oldest,
          completed: false,
        );
      }
      final range = DateRange(month, DateTime(month.year, month.month + 1));
      progress = HealthHistoryProgress(
        month: month,
        activityDays: progress.activityDays,
        workouts: progress.workouts,
        bodyEntries: progress.bodyEntries,
        recoveryDays: progress.recoveryDays,
      );
      onProgress(progress);

      // Activity is the core of the import; if it fails, stop and say so.
      final activityDays = (await _activity.importFromHealth(range))
          .getOrThrow();
      // The rest are best-effort: a type the user didn't allow must not stop
      // the others.
      final workouts = (await _tracked.importFromHealth(range)).dataOrNull ?? 0;
      final body = (await _body.importFromHealth(range)).dataOrNull ?? 0;
      final recoveryDays = await _importRecovery(range);

      final found = activityDays + workouts + body + recoveryDays;
      progress = HealthHistoryProgress(
        month: month,
        activityDays: progress.activityDays + activityDays,
        workouts: progress.workouts + workouts,
        bodyEntries: progress.bodyEntries + body,
        recoveryDays: progress.recoveryDays + recoveryDays,
      );
      onProgress(progress);

      if (found > 0) {
        foundAny = true;
        emptyStreak = 0;
        oldest = month;
      } else {
        emptyStreak++;
        if (emptyStreak >= (foundAny ? _gapAfterData : _gapBeforeAnyData)) {
          break;
        }
      }
      month = DateTime(month.year, month.month - 1);
    }

    if (oldest != null) {
      await _settings.setSetting(_historyOldestKey, oldest.toIso8601String());
    }
    await _settings.setSetting(_historyDoneKey, '1');
    await _settings.setSetting(_lastSyncKey, _clock.now().toIso8601String());
    return HealthHistoryReport(
      progress: progress,
      oldest: oldest,
      completed: true,
    );
  });

  Future<int> _importRecovery(DateRange range) async {
    try {
      final records = await _health.getRecoveryHistory(range);
      await _recovery.upsertAll([
        for (final r in records)
          RecoveryHistoryCompanion(
            day: Value(_dayKey(r.date)),
            asleepMinutes: Value(r.asleepMinutes),
            awakeMinutes: Value(r.awakeMinutes),
            remMinutes: Value(r.remMinutes),
            lightMinutes: Value(r.lightMinutes),
            deepMinutes: Value(r.deepMinutes),
            bedtime: Value(r.bedtime),
            wakeTime: Value(r.wakeTime),
            hrvMs: Value(r.hrvMs),
            restingHr: Value(r.restingHr),
          ),
      ]);
      return records.length;
    } on Object {
      return 0;
    }
  }

  static String _dayKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Future<DateTime?> getHistoryOldest() async {
    final raw = await _settings.getSetting(_historyOldestKey);
    return raw == null ? null : DateTime.tryParse(raw);
  }

  @override
  Future<bool> isHistoryComplete() async =>
      await _settings.getSetting(_historyDoneKey) == '1';
}
