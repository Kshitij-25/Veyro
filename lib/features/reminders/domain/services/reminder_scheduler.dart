import 'package:fitness_trakcer/features/reminders/domain/entities/reminder.dart';

/// Schedules repeating local notifications for reminders.
abstract interface class ReminderScheduler {
  /// Asks the OS for notification permission; returns whether it is granted.
  Future<bool> requestPermission();

  /// Replaces any existing schedule for the reminder.
  Future<void> schedule(Reminder reminder);

  Future<void> cancel(int reminderId);

  Future<void> cancelAll();
}
