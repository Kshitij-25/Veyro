import 'package:drift/drift.dart';
import 'package:fitness_trakcer/core/database/app_database.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GoalLocalDataSource {
  const GoalLocalDataSource(this._db);

  final AppDatabase _db;

  SimpleSelectStatement<$GoalsTable, GoalRow> _ordered() =>
      _db.select(_db.goals)..orderBy([(t) => OrderingTerm.asc(t.createdAt)]);

  Stream<List<GoalRow>> watchAll() => _ordered().watch();

  Future<List<GoalRow>> getAll() => _ordered().get();

  Future<void> upsert(GoalsCompanion goal) =>
      _db.into(_db.goals).insertOnConflictUpdate(goal);

  Future<void> delete(String id) =>
      (_db.delete(_db.goals)..where((t) => t.id.equals(id))).go();
}
