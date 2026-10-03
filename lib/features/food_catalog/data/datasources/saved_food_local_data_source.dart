import 'package:drift/drift.dart';
import 'package:fitness_trakcer/core/database/app_database.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SavedFoodLocalDataSource {
  const SavedFoodLocalDataSource(this._db);

  final AppDatabase _db;

  Stream<List<SavedFoodRow>> watchAll() => (_db.select(
    _db.savedFoods,
  )..orderBy([(t) => OrderingTerm.asc(t.name)])).watch();

  Future<List<SavedFoodRow>> search(String query) =>
      (_db.select(_db.savedFoods)
            ..where((t) => t.name.like('%$query%') | t.brand.like('%$query%'))
            ..limit(15))
          .get();

  Future<SavedFoodRow?> get(String id) => (_db.select(
    _db.savedFoods,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> upsert(SavedFoodsCompanion food) =>
      _db.into(_db.savedFoods).insertOnConflictUpdate(food);

  Future<void> delete(String id) =>
      (_db.delete(_db.savedFoods)..where((t) => t.id.equals(id))).go();
}
