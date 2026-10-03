import 'package:fitness_trakcer/core/error/failure_exception.dart';
import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/reminders/data/datasources/reminder_local_data_source.dart';
import 'package:fitness_trakcer/features/reminders/data/mappers/reminder_mapper.dart';
import 'package:fitness_trakcer/features/reminders/domain/entities/reminder.dart';
import 'package:fitness_trakcer/features/reminders/domain/repositories/reminder_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ReminderRepository)
class ReminderRepositoryImpl implements ReminderRepository {
  const ReminderRepositoryImpl(this._localDataSource);

  final ReminderLocalDataSource _localDataSource;

  @override
  Stream<List<Reminder>> watchReminders() => _localDataSource.watchAll().map(
    (rows) => rows.map((row) => row.toEntity()).toList(),
  );

  @override
  Future<Result<List<Reminder>>> getReminders() => guard(() async {
    final rows = await _localDataSource.getAll();
    return rows.map((row) => row.toEntity()).toList();
  });

  @override
  Future<Result<Reminder>> getReminder(int id) => guard(() async {
    final row = await _localDataSource.getById(id);
    if (row == null) {
      throw const FailureException(NotFoundFailure('Reminder not found.'));
    }
    return row.toEntity();
  });

  @override
  Future<Result<Reminder>> saveReminder(Reminder reminder) => guard(() async {
    final row = await _localDataSource.upsert(reminder.toCompanion());
    return row.toEntity();
  });

  @override
  Future<Result<void>> deleteReminder(int id) =>
      guard(() => _localDataSource.delete(id));
}
