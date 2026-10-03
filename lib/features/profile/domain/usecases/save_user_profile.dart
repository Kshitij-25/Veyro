import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/clock.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/profile/domain/entities/user_profile.dart';
import 'package:fitness_trakcer/features/profile/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SaveUserProfile implements UseCase<void, UserProfile> {
  const SaveUserProfile(this._repository, this._clock);

  final ProfileRepository _repository;
  final Clock _clock;

  @override
  Future<Result<void>> call(UserProfile params) {
    final now = _clock.now();
    if (params.name.trim().isEmpty) {
      return Future.value(const Fail(ValidationFailure('Name is required.')));
    }
    if (params.heightCm < 50 || params.heightCm > 272) {
      return Future.value(
        const Fail(ValidationFailure('Height must be between 50 and 272 cm.')),
      );
    }
    if (params.weightKg < 20 || params.weightKg > 500) {
      return Future.value(
        const Fail(ValidationFailure('Weight must be between 20 and 500 kg.')),
      );
    }
    if (params.ageOn(now) < 13 || params.birthDate.isAfter(now)) {
      return Future.value(
        const Fail(ValidationFailure('You must be at least 13 years old.')),
      );
    }
    return _repository.saveProfile(
      params.copyWith(name: params.name.trim(), updatedAt: now),
    );
  }
}
