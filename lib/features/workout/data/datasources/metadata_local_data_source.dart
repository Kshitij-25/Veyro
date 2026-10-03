import 'package:drift/drift.dart';
import 'package:fitness_trakcer/core/database/app_database.dart';
import 'package:injectable/injectable.dart';

/// Tiny key/value store backed by the `app_metadata` table.
@lazySingleton
class MetadataLocalDataSource {
  const MetadataLocalDataSource(this._db);

  static const wgerLastSyncKey = 'wger_last_sync';

  final AppDatabase _db;

  Future<String?> get(String key) async {
    final row = await (_db.select(
      _db.appMetadata,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> set(String key, String value) => _db
      .into(_db.appMetadata)
      .insertOnConflictUpdate(
        AppMetadataCompanion(key: Value(key), value: Value(value)),
      );
}
