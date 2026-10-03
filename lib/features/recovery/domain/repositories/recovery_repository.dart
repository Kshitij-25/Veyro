import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/recovery/domain/entities/heart_rate_zones.dart';
import 'package:fitness_trakcer/features/recovery/domain/entities/recovery_snapshot.dart';

abstract interface class RecoveryRepository {
  /// The last [days] days (including today), read from the health store.
  Future<Result<RecoverySnapshot>> getSnapshot({
    required DateTime now,
    int days,
  });

  /// Heart-rate samples from the last [days] days, oldest first.
  Future<Result<List<HeartRateSampleInput>>> getHeartRateSamples({
    required DateTime now,
    required int days,
  });
}
