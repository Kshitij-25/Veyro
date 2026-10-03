import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/progress_photos/domain/entities/check_in.dart';

abstract interface class CheckInRepository {
  /// Newest first.
  Stream<List<CheckIn>> watchCheckIns();

  Future<Result<void>> create(CheckIn checkIn);

  /// Copies the file at [sourcePath] into app storage for [angle].
  Future<Result<void>> setPhoto(
    String checkInId,
    PhotoAngle angle,
    String sourcePath,
  );

  Future<Result<void>> removePhoto(String checkInId, PhotoAngle angle);

  /// Deletes the check-in and its photos.
  Future<Result<void>> delete(String checkInId);
}
