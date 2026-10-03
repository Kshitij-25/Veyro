import 'package:drift/drift.dart';

/// Cached per-day activity totals, keyed by `DateTime.dayKey`.
@DataClassName('DailyActivityRow')
class DailyActivities extends Table {
  IntColumn get dayKey => integer()();
  IntColumn get steps => integer().withDefault(const Constant(0))();
  RealColumn get distanceMeters => real().withDefault(const Constant(0))();
  RealColumn get activeCaloriesKcal => real().withDefault(const Constant(0))();
  TextColumn get source => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {dayKey};
}
