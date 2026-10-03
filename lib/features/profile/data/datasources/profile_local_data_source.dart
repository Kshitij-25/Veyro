import 'package:fitness_trakcer/core/database/app_database.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ProfileLocalDataSource {
  const ProfileLocalDataSource(this._db);

  final AppDatabase _db;

  Stream<UserProfileRow?> watchProfile() =>
      _db.select(_db.userProfiles).watchSingleOrNull();

  Future<UserProfileRow?> getProfile() =>
      _db.select(_db.userProfiles).getSingleOrNull();

  Future<void> upsertProfile(UserProfilesCompanion profile) =>
      _db.into(_db.userProfiles).insertOnConflictUpdate(profile);
}
