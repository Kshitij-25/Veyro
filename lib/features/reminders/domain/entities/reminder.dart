import 'package:fitness_trakcer/features/reminders/domain/entities/reminder_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder.freezed.dart';

@freezed
abstract class Reminder with _$Reminder {
  const factory Reminder({
    /// Assigned by storage; use [unsavedId] for a reminder that isn't saved.
    required int id,
    required ReminderType type,
    required String title,
    required int hour,
    required int minute,
    String? body,

    /// ISO weekdays (1 = Monday … 7 = Sunday); empty means every day.
    @Default({}) Set<int> weekdays,
    @Default(true) bool isEnabled,
  }) = _Reminder;

  const Reminder._();

  static const unsavedId = 0;

  bool get isDaily => weekdays.isEmpty || weekdays.length == 7;
}
