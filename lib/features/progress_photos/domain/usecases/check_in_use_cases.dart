import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/clock.dart';
import 'package:fitness_trakcer/core/utils/id_generator.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/repositories/body_metrics_repository.dart';
import 'package:fitness_trakcer/features/progress_photos/domain/entities/check_in.dart';
import 'package:fitness_trakcer/features/progress_photos/domain/repositories/check_in_repository.dart';
import 'package:fitness_trakcer/features/progress_photos/domain/services/photo_picker.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class WatchCheckIns implements StreamUseCase<List<CheckIn>, NoParams> {
  const WatchCheckIns(this._repository);

  final CheckInRepository _repository;

  @override
  Stream<List<CheckIn>> call(NoParams params) => _repository.watchCheckIns();
}

/// Starts a check-in stamped with now and the latest logged weight.
@lazySingleton
class CreateCheckIn implements UseCase<CheckIn, NoParams> {
  const CreateCheckIn(this._repository, this._body, this._ids, this._clock);

  final CheckInRepository _repository;
  final BodyMetricsRepository _body;
  final IdGenerator _ids;
  final Clock _clock;

  @override
  Future<Result<CheckIn>> call(NoParams params) async {
    final weight = (await _body.getLatestWithWeight()).dataOrNull?.weightKg;
    final checkIn = CheckIn(
      id: _ids.generate(),
      takenAt: _clock.now(),
      weightKg: weight,
    );
    final saved = await _repository.create(checkIn);
    return saved.map((_) => checkIn);
  }
}

class SetCheckInPhotoParams {
  const SetCheckInPhotoParams(this.checkInId, this.angle, this.source);

  final String checkInId;
  final PhotoAngle angle;
  final PhotoSource source;
}

/// Picks a photo and attaches it. Succeeds with `false` if the user cancelled.
@lazySingleton
class SetCheckInPhoto implements UseCase<bool, SetCheckInPhotoParams> {
  const SetCheckInPhoto(this._repository, this._picker);

  final CheckInRepository _repository;
  final PhotoPicker _picker;

  @override
  Future<Result<bool>> call(SetCheckInPhotoParams params) => guard(() async {
    final path = await _picker.pick(params.source);
    if (path == null) return false;
    (await _repository.setPhoto(
      params.checkInId,
      params.angle,
      path,
    )).getOrThrow();
    return true;
  });
}

class RemoveCheckInPhotoParams {
  const RemoveCheckInPhotoParams(this.checkInId, this.angle);

  final String checkInId;
  final PhotoAngle angle;
}

@lazySingleton
class RemoveCheckInPhoto implements UseCase<void, RemoveCheckInPhotoParams> {
  const RemoveCheckInPhoto(this._repository);

  final CheckInRepository _repository;

  @override
  Future<Result<void>> call(RemoveCheckInPhotoParams params) =>
      _repository.removePhoto(params.checkInId, params.angle);
}

@lazySingleton
class DeleteCheckIn implements UseCase<void, String> {
  const DeleteCheckIn(this._repository);

  final CheckInRepository _repository;

  @override
  Future<Result<void>> call(String params) => _repository.delete(params);
}
