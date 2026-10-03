import 'package:drift/drift.dart';
import 'package:fitness_trakcer/core/database/app_database.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RecoveryHistoryLocalDataSource {
  const RecoveryHistoryLocalDataSource(this._db);

  final AppDatabase _db;

  Future<void> upsertAll(List<RecoveryHistoryCompanion> rows) => _db.batch(
    (batch) => batch.insertAllOnConflictUpdate(_db.recoveryHistory, rows),
  );

  /// Every stored day, oldest first.
  Future<List<RecoveryHistoryRow>> all() => (_db.select(
    _db.recoveryHistory,
  )..orderBy([(t) => OrderingTerm.asc(t.day)])).get();
}
