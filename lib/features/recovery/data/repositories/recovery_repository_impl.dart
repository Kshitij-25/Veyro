import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/activity/data/datasources/health_data_source.dart';
import 'package:fitness_trakcer/features/recovery/domain/entities/recovery_snapshot.dart';
import 'package:fitness_trakcer/features/recovery/domain/repositories/recovery_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: RecoveryRepository)
class RecoveryRepositoryImpl implements RecoveryRepository {
  const RecoveryRepositoryImpl(this._health);

  final HealthDataSource _health;

  @override
  Future<Result<RecoverySnapshot>> getSnapshot({
    required DateTime now,
    int days = 15,
  }) => guard(() async {
    final readings = await _health.getRecoveryDays(
      DateRange.lastDays(days, until: now),
    );
    return RecoverySnapshot([
      for (final r in readings)
        RecoveryDay(
          date: r.date,
          hrvMs: r.hrvMs,
          restingHr: r.restingHr,
          sleepMinutes: r.sleepMinutes,
        ),
    ]);
  });
}
