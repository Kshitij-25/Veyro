import 'package:drift/drift.dart';
import 'package:fitness_trakcer/core/database/app_database.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/progress_photos/data/datasources/check_in_local_data_source.dart';
import 'package:fitness_trakcer/features/progress_photos/data/services/photo_file_store.dart';
import 'package:fitness_trakcer/features/progress_photos/domain/entities/check_in.dart';
import 'package:fitness_trakcer/features/progress_photos/domain/repositories/check_in_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;

@LazySingleton(as: CheckInRepository)
class CheckInRepositoryImpl implements CheckInRepository {
  const CheckInRepositoryImpl(this._local, this._files);

  final CheckInLocalDataSource _local;
  final PhotoFileStore _files;

  @override
  Stream<List<CheckIn>> watchCheckIns() =>
      _local.watchAll().asyncMap((rows) async {
        final dir = await _files.directoryPath();
        return [
          for (final r in rows)
            CheckIn(
              id: r.checkIn.id,
              takenAt: r.checkIn.takenAt,
              weightKg: r.checkIn.weightKg,
              photos: {
                for (final photo in r.photos)
                  for (final angle in PhotoAngle.values)
                    if (angle.name == photo.angle)
                      angle: p.join(dir, photo.fileName),
              },
            ),
        ];
      });

  @override
  Future<Result<void>> create(CheckIn checkIn) => guard(
    () => _local.insert(
      ProgressCheckInsCompanion.insert(
        id: checkIn.id,
        takenAt: checkIn.takenAt,
        weightKg: Value(checkIn.weightKg),
      ),
    ),
  );

  @override
  Future<Result<void>> setPhoto(
    String checkInId,
    PhotoAngle angle,
    String sourcePath,
  ) => guard(() async {
    final old = await _local.getFileName(checkInId, angle.name);
    final fileName = await _files.save(sourcePath, '$checkInId-${angle.name}');
    await _local.upsertPhoto(
      ProgressPhotosCompanion.insert(
        checkInId: checkInId,
        angle: angle.name,
        fileName: fileName,
      ),
    );
    if (old != null) await _files.delete(old);
  });

  @override
  Future<Result<void>> removePhoto(String checkInId, PhotoAngle angle) =>
      guard(() async {
        final old = await _local.getFileName(checkInId, angle.name);
        await _local.deletePhoto(checkInId, angle.name);
        if (old != null) await _files.delete(old);
      });

  @override
  Future<Result<void>> delete(String checkInId) => guard(() async {
    final names = await _local.fileNamesOf(checkInId);
    await _local.delete(checkInId);
    for (final name in names) {
      await _files.delete(name);
    }
  });
}
