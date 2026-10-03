import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/features/profile/domain/entities/user_profile.dart';
import 'package:fitness_trakcer/features/profile/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class WatchUserProfile implements StreamUseCase<UserProfile?, NoParams> {
  const WatchUserProfile(this._repository);

  final ProfileRepository _repository;

  @override
  Stream<UserProfile?> call(NoParams params) => _repository.watchProfile();
}
