import 'package:drift/drift.dart';
import 'package:fitness_trakcer/core/database/app_database.dart';
import 'package:fitness_trakcer/core/extensions/date_time_extensions.dart';
import 'package:fitness_trakcer/features/reminders/domain/entities/reminder.dart';
import 'package:fitness_trakcer/features/reminders/domain/entities/reminder_type.dart';

extension ReminderRowMapper on ReminderRow {
  Reminder toEntity() => Reminder(
    id: id,
    type: ReminderType.values.byName(type),
    title: title,
    body: body,
    hour: hour,
    minute: minute,
    weekdays: weekdaysMask.toWeekdaySet(),
    isEnabled: isEnabled,
  );
}

extension ReminderEntityMapper on Reminder {
  RemindersCompanion toCompanion() => RemindersCompanion(
    id: id == Reminder.unsavedId ? const Value.absent() : Value(id),
    type: Value(type.name),
    title: Value(title),
    body: Value(body),
    hour: Value(hour),
    minute: Value(minute),
    weekdaysMask: Value(weekdays.toWeekdayMask()),
    isEnabled: Value(isEnabled),
  );
}
