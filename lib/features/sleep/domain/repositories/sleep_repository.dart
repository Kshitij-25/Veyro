import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/sleep/domain/entities/sleep_night.dart';

abstract interface class SleepRepository {
  /// Nights that ended in the last [days] days, oldest first. Nights with no
  /// recorded sleep are omitted.
  Future<Result<List<SleepNight>>> getNights({
    required DateTime now,
    required int days,
  });

  /// Every imported night with recorded sleep, oldest first.
  Future<Result<List<SleepDay>>> getHistory();
}
