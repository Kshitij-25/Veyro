import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/health_sync/domain/entities/health_history.dart';
import 'package:fitness_trakcer/features/health_sync/domain/entities/health_sync_report.dart';

abstract interface class HealthSyncRepository {
  /// Pulls the last [days] days of activity and body measurements from the
  /// platform health store into the local database.
  Future<Result<HealthSyncReport>> sync({required int days});

  /// When a sync last completed, or `null` if never.
  Future<DateTime?> getLastSync();

  /// Whether the user has connected Health at least once.
  Future<bool> wasConnected();

  Future<void> markConnected();

  Future<Result<void>> installProvider();

  /// Imports everything Health holds, newest month first, until a long
  /// stretch has no data. [onProgress] is called after each month and
  /// [isCancelled] is checked between months. Safe to run again: nothing is
  /// duplicated.
  Future<Result<HealthHistoryReport>> importHistory({
    required void Function(HealthHistoryProgress progress) onProgress,
    required bool Function() isCancelled,
  });

  /// Earliest month with data from a finished history import, or `null`.
  Future<DateTime?> getHistoryOldest();

  /// Whether a full history import ran to the end.
  Future<bool> isHistoryComplete();
}
