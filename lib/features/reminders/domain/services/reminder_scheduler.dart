import 'package:fitness_trakcer/features/reminders/domain/entities/reminder.dart';

/// Schedules repeating local notifications for reminders.
abstract interface class ReminderScheduler {
  /// Asks the OS for notification permission; returns whether it is granted.
  Future<bool> requestPermission();

  /// Replaces any existing schedule for the reminder.
  Future<void> schedule(Reminder reminder);

  Future<void> cancel(int reminderId);

  /// Schedules a single notification at [at], replacing any earlier one with
  /// the same [id]. Use ids that can't collide with reminder ids.
  Future<void> scheduleOnce({
    required int id,
    required String title,
    required String body,
    required DateTime at,
  });

  Future<void> cancelOnce(int id);

  Future<void> cancelAll();
}
