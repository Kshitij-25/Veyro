import 'package:drift/drift.dart';
import 'package:fitness_trakcer/core/database/app_database.dart';
import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class BodyMetricsLocalDataSource {
  const BodyMetricsLocalDataSource(this._db);

  final AppDatabase _db;

  Stream<List<BodyMeasurementRow>> watchAll() {
    final query = _db.select(_db.bodyMeasurements)
      ..orderBy([(t) => OrderingTerm.desc(t.measuredAt)]);
    return query.watch();
  }

  Future<List<BodyMeasurementRow>> getRange(DateRange range) {
    final query = _db.select(_db.bodyMeasurements)
      ..where((t) => t.measuredAt.isBiggerOrEqualValue(range.start))
      ..where((t) => t.measuredAt.isSmallerThanValue(range.end))
      ..orderBy([(t) => OrderingTerm.asc(t.measuredAt)]);
    return query.get();
  }

  Future<BodyMeasurementRow?> getLatestWithWeight() {
    final query = _db.select(_db.bodyMeasurements)
      ..where((t) => t.weightKg.isNotNull())
      ..orderBy([(t) => OrderingTerm.desc(t.measuredAt)])
      ..limit(1);
    return query.getSingleOrNull();
  }

  Future<void> upsert(BodyMeasurementsCompanion measurement) =>
      _db.into(_db.bodyMeasurements).insertOnConflictUpdate(measurement);

  Future<void> delete(String id) =>
      (_db.delete(_db.bodyMeasurements)..where((t) => t.id.equals(id))).go();
}
