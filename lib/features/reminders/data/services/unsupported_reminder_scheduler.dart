import 'package:fitness_trakcer/features/reminders/domain/entities/reminder.dart';
import 'package:fitness_trakcer/features/reminders/domain/services/reminder_scheduler.dart';

/// Used where local notifications aren't available (web, Linux, Windows).
/// Reminders are still stored; they just never fire.
class UnsupportedReminderScheduler implements ReminderScheduler {
  const UnsupportedReminderScheduler();

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<void> schedule(Reminder reminder) async {}

  @override
  Future<void> cancel(int reminderId) async {}

  @override
  Future<void> scheduleOnce({
    required int id,
    required String title,
    required String body,
    required DateTime at,
  }) async {}

  @override
  Future<void> cancelOnce(int id) async {}

  @override
  Future<void> cancelAll() async {}
}
