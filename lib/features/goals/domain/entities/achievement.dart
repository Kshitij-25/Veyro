import 'package:fitness_trakcer/features/goals/domain/entities/achievement_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'achievement.freezed.dart';

@freezed
abstract class Achievement with _$Achievement {
  const factory Achievement({
    required AchievementType type,

    /// `null` while still locked.
    DateTime? unlockedAt,
  }) = _Achievement;

  const Achievement._();

  bool get isUnlocked => unlockedAt != null;
}
