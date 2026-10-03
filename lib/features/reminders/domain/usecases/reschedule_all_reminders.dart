import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/reminders/domain/repositories/reminder_repository.dart';
import 'package:fitness_trakcer/features/reminders/domain/services/reminder_scheduler.dart';
import 'package:injectable/injectable.dart';

/// Rebuilds every notification schedule from storage. Run on app start so
/// reminders survive reinstalls, reboots and timezone changes.
@lazySingleton
class RescheduleAllReminders implements UseCase<void, NoParams> {
  const RescheduleAllReminders(this._repository, this._scheduler);

  final ReminderRepository _repository;
  final ReminderScheduler _scheduler;

  @override
  Future<Result<void>> call(NoParams params) async {
    final reminders = await _repository.getReminders();
    if (reminders case Fail(:final failure)) return Fail(failure);
    return guard(() async {
      await _scheduler.cancelAll();
      for (final reminder in reminders.dataOrNull!) {
        if (reminder.isEnabled) await _scheduler.schedule(reminder);
      }
    });
  }
}
