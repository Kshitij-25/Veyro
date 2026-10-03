import 'package:drift/drift.dart';
import 'package:fitness_trakcer/core/database/app_database.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AchievementLocalDataSource {
  const AchievementLocalDataSource(this._db);

  final AppDatabase _db;

  Stream<List<UnlockedAchievementRow>> watchAll() =>
      _db.select(_db.unlockedAchievements).watch();

  Future<List<UnlockedAchievementRow>> getAll() =>
      _db.select(_db.unlockedAchievements).get();

  Future<void> insert(UnlockedAchievementsCompanion achievement) => _db
      .into(_db.unlockedAchievements)
      .insert(achievement, mode: InsertMode.insertOrIgnore);
}
