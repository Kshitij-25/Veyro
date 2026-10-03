import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/reminders/domain/services/reminder_scheduler.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RequestReminderPermission implements UseCase<bool, NoParams> {
  const RequestReminderPermission(this._scheduler);

  final ReminderScheduler _scheduler;

  @override
  Future<Result<bool>> call(NoParams params) =>
      guard(_scheduler.requestPermission);
}
