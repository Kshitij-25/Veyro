import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/profile/domain/entities/user_profile.dart';

abstract interface class ProfileRepository {
  /// Emits `null` until onboarding has been completed.
  Stream<UserProfile?> watchProfile();

  Future<Result<UserProfile?>> getProfile();

  Future<Result<void>> saveProfile(UserProfile profile);
}
