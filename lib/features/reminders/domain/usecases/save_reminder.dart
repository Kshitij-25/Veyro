import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/reminders/domain/entities/reminder.dart';
import 'package:fitness_trakcer/features/reminders/domain/repositories/reminder_repository.dart';
import 'package:fitness_trakcer/features/reminders/domain/services/reminder_scheduler.dart';
import 'package:injectable/injectable.dart';

/// Saves a reminder and (re)schedules or cancels its notifications.
@lazySingleton
class SaveReminder implements UseCase<Reminder, Reminder> {
  const SaveReminder(this._repository, this._scheduler);

  final ReminderRepository _repository;
  final ReminderScheduler _scheduler;

  @override
  Future<Result<Reminder>> call(Reminder params) async {
    if (params.title.trim().isEmpty) {
      return const Fail(ValidationFailure('Title is required.'));
    }
    if (params.hour < 0 ||
        params.hour > 23 ||
        params.minute < 0 ||
        params.minute > 59) {
      return const Fail(ValidationFailure('Choose a valid time.'));
    }
    final saved = await _repository.saveReminder(
      params.copyWith(title: params.title.trim()),
    );
    if (saved case Success(:final data)) {
      return guard(() async {
        if (data.isEnabled) {
          await _scheduler.schedule(data);
        } else {
          await _scheduler.cancel(data.id);
        }
        return data;
      });
    }
    return saved;
  }
}
