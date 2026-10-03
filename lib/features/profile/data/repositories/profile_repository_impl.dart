import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:fitness_trakcer/features/profile/data/mappers/user_profile_mapper.dart';
import 'package:fitness_trakcer/features/profile/domain/entities/user_profile.dart';
import 'package:fitness_trakcer/features/profile/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._localDataSource);

  final ProfileLocalDataSource _localDataSource;

  @override
  Stream<UserProfile?> watchProfile() =>
      _localDataSource.watchProfile().map((row) => row?.toEntity());

  @override
  Future<Result<UserProfile?>> getProfile() => guard(() async {
    final row = await _localDataSource.getProfile();
    return row?.toEntity();
  });

  @override
  Future<Result<void>> saveProfile(UserProfile profile) =>
      guard(() => _localDataSource.upsertProfile(profile.toCompanion()));
}
