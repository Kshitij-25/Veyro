import 'package:drift/drift.dart';
import 'package:fitness_trakcer/core/database/app_database.dart';
import 'package:injectable/injectable.dart';

class CheckInWithPhotos {
  const CheckInWithPhotos(this.checkIn, this.photos);

  final CheckInRow checkIn;
  final List<CheckInPhotoRow> photos;
}

@lazySingleton
class CheckInLocalDataSource {
  const CheckInLocalDataSource(this._db);

  final AppDatabase _db;

  Stream<List<CheckInWithPhotos>> watchAll() {
    final query = _db.select(_db.progressCheckIns).join([
      leftOuterJoin(
        _db.progressPhotos,
        _db.progressPhotos.checkInId.equalsExp(_db.progressCheckIns.id),
      ),
    ])..orderBy([OrderingTerm.desc(_db.progressCheckIns.takenAt)]);
    return query.watch().map((rows) {
      final byId = <String, CheckInWithPhotos>{};
      for (final row in rows) {
        final checkIn = row.readTable(_db.progressCheckIns);
        final photo = row.readTableOrNull(_db.progressPhotos);
        final entry = byId.putIfAbsent(
          checkIn.id,
          () => CheckInWithPhotos(checkIn, []),
        );
        if (photo != null) entry.photos.add(photo);
      }
      return byId.values.toList();
    });
  }

  Future<void> insert(ProgressCheckInsCompanion checkIn) =>
      _db.into(_db.progressCheckIns).insert(checkIn);

  Future<String?> getFileName(String checkInId, String angle) async {
    final row =
        await (_db.select(_db.progressPhotos)..where(
              (t) => t.checkInId.equals(checkInId) & t.angle.equals(angle),
            ))
            .getSingleOrNull();
    return row?.fileName;
  }

  Future<void> upsertPhoto(ProgressPhotosCompanion photo) =>
      _db.into(_db.progressPhotos).insertOnConflictUpdate(photo);

  Future<void> deletePhoto(String checkInId, String angle) => (_db.delete(
    _db.progressPhotos,
  )..where((t) => t.checkInId.equals(checkInId) & t.angle.equals(angle))).go();

  Future<List<String>> fileNamesOf(String checkInId) async {
    final rows = await (_db.select(
      _db.progressPhotos,
    )..where((t) => t.checkInId.equals(checkInId))).get();
    return [for (final r in rows) r.fileName];
  }

  Future<void> delete(String checkInId) => (_db.delete(
    _db.progressCheckIns,
  )..where((t) => t.id.equals(checkInId))).go();
}
