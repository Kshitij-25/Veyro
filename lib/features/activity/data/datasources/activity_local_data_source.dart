import 'package:drift/drift.dart';
import 'package:fitness_trakcer/core/database/app_database.dart';
import 'package:fitness_trakcer/core/extensions/date_time_extensions.dart';
import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ActivityLocalDataSource {
  const ActivityLocalDataSource(this._db);

  final AppDatabase _db;

  Stream<DailyActivityRow?> watchDay(DateTime date) => (_db.select(
    _db.dailyActivities,
  )..where((t) => t.dayKey.equals(date.dayKey))).watchSingleOrNull();

  Future<List<DailyActivityRow>> getRange(DateRange range) {
    final lastDay = DateTime(
      range.end.year,
      range.end.month,
      range.end.day - 1,
    );
    return (_db.select(_db.dailyActivities)
          ..where(
            (t) => t.dayKey.isBetweenValues(range.start.dayKey, lastDay.dayKey),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.dayKey)]))
        .get();
  }

  Future<void> upsert(DailyActivitiesCompanion activity) =>
      _db.into(_db.dailyActivities).insertOnConflictUpdate(activity);

  Future<void> upsertAll(List<DailyActivitiesCompanion> activities) =>
      _db.batch(
        (batch) =>
            batch.insertAllOnConflictUpdate(_db.dailyActivities, activities),
      );
}
