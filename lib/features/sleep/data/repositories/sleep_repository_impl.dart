import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/activity/data/datasources/health_data_source.dart';
import 'package:fitness_trakcer/features/activity/data/models/health_sleep_night.dart';
import 'package:fitness_trakcer/features/health_sync/data/datasources/recovery_history_local_data_source.dart';
import 'package:fitness_trakcer/features/sleep/domain/entities/sleep_night.dart';
import 'package:fitness_trakcer/features/sleep/domain/repositories/sleep_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SleepRepository)
class SleepRepositoryImpl implements SleepRepository {
  const SleepRepositoryImpl(this._health, this._history);

  final HealthDataSource _health;
  final RecoveryHistoryLocalDataSource _history;

  @override
  Future<Result<List<SleepNight>>> getNights({
    required DateTime now,
    required int days,
  }) => guard(() async {
    final nights = await _health.getSleepNights(
      DateRange.lastDays(days, until: now),
    );
    return [
      for (final n in nights)
        SleepNight(
          date: n.date,
          sleepingHr: n.sleepingHr,
          segments: [
            for (final s in n.segments)
              SleepSegment(_stage(s.stage), s.start, s.end),
          ],
        ),
    ];
  });

  static SleepStage _stage(HealthSleepStage s) => switch (s) {
    HealthSleepStage.awake => SleepStage.awake,
    HealthSleepStage.rem => SleepStage.rem,
    HealthSleepStage.light => SleepStage.light,
    HealthSleepStage.deep => SleepStage.deep,
    HealthSleepStage.asleep => SleepStage.asleep,
  };

  @override
  Future<Result<List<SleepDay>>> getHistory() => guard(() async {
    final rows = await _history.all();
    return [
      for (final r in rows)
        if (r.asleepMinutes != null && r.asleepMinutes! > 0)
          SleepDay(
            date: DateTime.parse(r.day),
            asleepMinutes: r.asleepMinutes!,
          ),
    ];
  });
}
