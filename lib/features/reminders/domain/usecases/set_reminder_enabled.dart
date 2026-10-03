import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/reminders/domain/entities/reminder.dart';
import 'package:fitness_trakcer/features/reminders/domain/repositories/reminder_repository.dart';
import 'package:fitness_trakcer/features/reminders/domain/usecases/save_reminder.dart';
import 'package:injectable/injectable.dart';

class SetReminderEnabledParams {
  const SetReminderEnabledParams(this.reminderId, {required this.enabled});

  final int reminderId;
  final bool enabled;
}

@lazySingleton
class SetReminderEnabled
    implements UseCase<Reminder, SetReminderEnabledParams> {
  const SetReminderEnabled(this._repository, this._saveReminder);

  final ReminderRepository _repository;
  final SaveReminder _saveReminder;

  @override
  Future<Result<Reminder>> call(SetReminderEnabledParams params) async {
    final existing = await _repository.getReminder(params.reminderId);
    if (existing case Fail(:final failure)) return Fail(failure);
    return _saveReminder(
      existing.dataOrNull!.copyWith(isEnabled: params.enabled),
    );
  }
}
