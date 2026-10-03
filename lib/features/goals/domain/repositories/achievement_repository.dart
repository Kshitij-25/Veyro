import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/goals/domain/entities/achievement.dart';
import 'package:fitness_trakcer/features/goals/domain/entities/achievement_type.dart';

abstract interface class AchievementRepository {
  /// Only achievements that have been unlocked.
  Stream<List<Achievement>> watchUnlocked();

  Future<Result<List<Achievement>>> getUnlocked();

  Future<Result<void>> unlock(AchievementType type, DateTime at);
}
