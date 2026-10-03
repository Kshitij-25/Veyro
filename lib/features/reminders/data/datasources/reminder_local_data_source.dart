import 'package:drift/drift.dart';
import 'package:fitness_trakcer/core/database/app_database.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ReminderLocalDataSource {
  const ReminderLocalDataSource(this._db);

  final AppDatabase _db;

  SimpleSelectStatement<$RemindersTable, ReminderRow> _ordered() =>
      _db.select(_db.reminders)..orderBy([
        (t) => OrderingTerm.asc(t.hour),
        (t) => OrderingTerm.asc(t.minute),
      ]);

  Stream<List<ReminderRow>> watchAll() => _ordered().watch();

  Future<List<ReminderRow>> getAll() => _ordered().get();

  Future<ReminderRow?> getById(int id) => (_db.select(
    _db.reminders,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Inserts or updates and returns the stored row.
  Future<ReminderRow> upsert(RemindersCompanion reminder) => _db
      .into(_db.reminders)
      .insertReturning(reminder, mode: InsertMode.insertOrReplace);

  Future<void> delete(int id) =>
      (_db.delete(_db.reminders)..where((t) => t.id.equals(id))).go();
}
