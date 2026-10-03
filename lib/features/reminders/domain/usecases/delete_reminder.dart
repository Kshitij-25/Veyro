import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/reminders/domain/repositories/reminder_repository.dart';
import 'package:fitness_trakcer/features/reminders/domain/services/reminder_scheduler.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DeleteReminder implements UseCase<void, int> {
  const DeleteReminder(this._repository, this._scheduler);

  final ReminderRepository _repository;
  final ReminderScheduler _scheduler;

  @override
  Future<Result<void>> call(int params) async {
    final cancelled = await guard(() => _scheduler.cancel(params));
    if (cancelled case Fail(:final failure)) return Fail(failure);
    return _repository.deleteReminder(params);
  }
}
