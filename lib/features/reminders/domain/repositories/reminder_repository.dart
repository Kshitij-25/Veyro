import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/reminders/domain/entities/reminder.dart';

abstract interface class ReminderRepository {
  /// Ordered by time of day.
  Stream<List<Reminder>> watchReminders();

  Future<Result<List<Reminder>>> getReminders();

  Future<Result<Reminder>> getReminder(int id);

  /// Inserts (when the id is `Reminder.unsavedId`) or updates; returns the
  /// stored reminder including its id.
  Future<Result<Reminder>> saveReminder(Reminder reminder);

  Future<Result<void>> deleteReminder(int id);
}
