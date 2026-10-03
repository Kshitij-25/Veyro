import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/profile/domain/entities/user_profile.dart';
import 'package:fitness_trakcer/features/profile/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetUserProfile implements UseCase<UserProfile?, NoParams> {
  const GetUserProfile(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Result<UserProfile?>> call(NoParams params) =>
      _repository.getProfile();
}
