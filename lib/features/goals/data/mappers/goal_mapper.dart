import 'package:drift/drift.dart';
import 'package:fitness_trakcer/core/database/app_database.dart';
import 'package:fitness_trakcer/features/goals/domain/entities/achievement.dart';
import 'package:fitness_trakcer/features/goals/domain/entities/achievement_type.dart';
import 'package:fitness_trakcer/features/goals/domain/entities/goal.dart';
import 'package:fitness_trakcer/features/goals/domain/entities/goal_type.dart';

extension GoalRowMapper on GoalRow {
  Goal toEntity() => Goal(
    id: id,
    type: GoalType.values.byName(type),
    targetValue: targetValue,
    startValue: startValue,
    startDate: startDate,
    deadline: deadline,
    isActive: isActive,
    createdAt: createdAt,
  );
}

extension GoalEntityMapper on Goal {
  GoalsCompanion toCompanion() => GoalsCompanion(
    id: Value(id),
    type: Value(type.name),
    targetValue: Value(targetValue),
    startValue: Value(startValue),
    startDate: Value(startDate),
    deadline: Value(deadline),
    isActive: Value(isActive),
    createdAt: Value(createdAt),
  );
}

extension UnlockedAchievementRowMapper on UnlockedAchievementRow {
  /// `null` when the stored id no longer exists in the app (removed type).
  Achievement? toEntity() {
    final type = AchievementType.values
        .where((t) => t.name == achievementId)
        .firstOrNull;
    return type == null
        ? null
        : Achievement(type: type, unlockedAt: unlockedAt);
  }
}
