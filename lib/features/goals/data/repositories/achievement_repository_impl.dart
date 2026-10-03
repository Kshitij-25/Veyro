import 'package:drift/drift.dart';
import 'package:fitness_trakcer/core/database/app_database.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/goals/data/datasources/achievement_local_data_source.dart';
import 'package:fitness_trakcer/features/goals/data/mappers/goal_mapper.dart';
import 'package:fitness_trakcer/features/goals/domain/entities/achievement.dart';
import 'package:fitness_trakcer/features/goals/domain/entities/achievement_type.dart';
import 'package:fitness_trakcer/features/goals/domain/repositories/achievement_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AchievementRepository)
class AchievementRepositoryImpl implements AchievementRepository {
  const AchievementRepositoryImpl(this._localDataSource);

  final AchievementLocalDataSource _localDataSource;

  @override
  Stream<List<Achievement>> watchUnlocked() =>
      _localDataSource.watchAll().map(_toEntities);

  @override
  Future<Result<List<Achievement>>> getUnlocked() =>
      guard(() async => _toEntities(await _localDataSource.getAll()));

  @override
  Future<Result<void>> unlock(AchievementType type, DateTime at) => guard(
    () => _localDataSource.insert(
      UnlockedAchievementsCompanion(
        achievementId: Value(type.name),
        unlockedAt: Value(at),
      ),
    ),
  );

  List<Achievement> _toEntities(List<UnlockedAchievementRow> rows) => [
    for (final row in rows) ?row.toEntity(),
  ];
}
