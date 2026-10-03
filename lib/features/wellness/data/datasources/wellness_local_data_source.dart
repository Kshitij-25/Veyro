import 'package:drift/drift.dart';
import 'package:fitness_trakcer/core/database/app_database.dart';
import 'package:injectable/injectable.dart';

/// Reads and writes the habit, food-diary, water and nutrition-target data.
@lazySingleton
class WellnessLocalDataSource {
  const WellnessLocalDataSource(this._db);

  final AppDatabase _db;

  // ---- settings (stored in the key/value metadata table) ----
  Future<String?> getSetting(String key) async {
    final row = await (_db.select(
      _db.appMetadata,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> setSetting(String key, String value) => _db
      .into(_db.appMetadata)
      .insertOnConflictUpdate(
        AppMetadataCompanion.insert(key: key, value: value),
      );

  // ---- water ----
  Future<int> getWater(String day) async {
    final row = await (_db.select(
      _db.waterLogs,
    )..where((t) => t.day.equals(day))).getSingleOrNull();
    return row?.ml ?? 0;
  }

  Future<void> setWater(String day, int ml) => _db
      .into(_db.waterLogs)
      .insertOnConflictUpdate(WaterLogsCompanion.insert(day: day, ml: ml));

  // ---- food ----
  Future<List<FoodLogRow>> getFood(String day) =>
      (_db.select(_db.foodLogEntries)
            ..where((t) => t.day.equals(day))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

  Future<void> addFood(FoodLogEntriesCompanion entry) =>
      _db.into(_db.foodLogEntries).insert(entry);

  Future<void> deleteFood(String id) =>
      (_db.delete(_db.foodLogEntries)..where((t) => t.id.equals(id))).go();

  // ---- habits ----
  Future<List<HabitRow>> getHabits() => (_db.select(
    _db.habits,
  )..orderBy([(t) => OrderingTerm.asc(t.createdAt)])).get();

  Future<void> addHabit(HabitsCompanion habit) =>
      _db.into(_db.habits).insert(habit);

  Future<void> deleteHabit(String id) =>
      (_db.delete(_db.habits)..where((t) => t.id.equals(id))).go();

  /// Completions on or after [fromDay] (`yyyy-MM-dd`).
  Future<List<HabitCompletionRow>> getCompletionsSince(String fromDay) =>
      (_db.select(
        _db.habitCompletions,
      )..where((t) => t.day.isBiggerOrEqualValue(fromDay))).get();

  Future<void> setCompletion(String habitId, String day, {required bool done}) {
    if (done) {
      return _db
          .into(_db.habitCompletions)
          .insertOnConflictUpdate(
            HabitCompletionsCompanion.insert(habitId: habitId, day: day),
          );
    }
    return (_db.delete(
      _db.habitCompletions,
    )..where((t) => t.habitId.equals(habitId) & t.day.equals(day))).go();
  }
}
