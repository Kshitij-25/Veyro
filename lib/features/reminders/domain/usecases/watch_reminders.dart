import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/features/reminders/domain/entities/reminder.dart';
import 'package:fitness_trakcer/features/reminders/domain/repositories/reminder_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class WatchReminders implements StreamUseCase<List<Reminder>, NoParams> {
  const WatchReminders(this._repository);

  final ReminderRepository _repository;

  @override
  Stream<List<Reminder>> call(NoParams params) => _repository.watchReminders();
}
