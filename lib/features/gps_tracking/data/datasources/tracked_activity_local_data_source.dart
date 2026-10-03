import 'package:drift/drift.dart';
import 'package:fitness_trakcer/core/database/app_database.dart';
import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class TrackedActivityLocalDataSource {
  const TrackedActivityLocalDataSource(this._db);

  final AppDatabase _db;

  Stream<List<TrackedActivityRow>> watchAll() => (_db.select(
    _db.trackedActivities,
  )..orderBy([(t) => OrderingTerm.desc(t.startedAt)])).watch();

  Future<List<TrackedActivityRow>> getRange(DateRange range) =>
      (_db.select(_db.trackedActivities)
            ..where((t) => t.startedAt.isBiggerOrEqualValue(range.start))
            ..where((t) => t.startedAt.isSmallerThanValue(range.end))
            ..orderBy([(t) => OrderingTerm.asc(t.startedAt)]))
          .get();

  Future<TrackedActivityRow?> getById(String id) => (_db.select(
    _db.trackedActivities,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> upsert(TrackedActivitiesCompanion activity) =>
      _db.into(_db.trackedActivities).insertOnConflictUpdate(activity);

  Future<void> delete(String id) =>
      (_db.delete(_db.trackedActivities)..where((t) => t.id.equals(id))).go();
}
