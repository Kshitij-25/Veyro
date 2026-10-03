import 'package:drift/drift.dart';

@DataClassName('ReminderRow')
class Reminders extends Table {
  /// Integer id because the OS notification APIs require int identifiers.
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()();
  TextColumn get title => text()();
  TextColumn get body => text().nullable()();
  IntColumn get hour => integer()();
  IntColumn get minute => integer()();

  /// ISO weekdays as a bitmask; `0` means every day.
  IntColumn get weekdaysMask => integer().withDefault(const Constant(0))();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();
}
