import 'package:drift/drift.dart';

@DataClassName('HabitRow')
class Habits extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get tag => text().withDefault(const Constant('Custom'))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// One row per habit per completed day (`day` is `yyyy-MM-dd`, local).
@DataClassName('HabitCompletionRow')
class HabitCompletions extends Table {
  TextColumn get habitId =>
      text().references(Habits, #id, onDelete: KeyAction.cascade)();
  TextColumn get day => text()();

  @override
  Set<Column> get primaryKey => {habitId, day};
}

@DataClassName('FoodLogRow')
class FoodLogEntries extends Table {
  TextColumn get id => text()();

  /// Local day, `yyyy-MM-dd`.
  TextColumn get day => text()();
  TextColumn get meal => text()();
  TextColumn get name => text()();
  TextColumn get serving => text()();

  /// Values for ONE serving; multiply by [quantity].
  RealColumn get kcal => real()();
  RealColumn get protein => real()();
  RealColumn get carbs => real()();
  RealColumn get fat => real()();
  RealColumn get quantity => real().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Total water drunk per local day, in millilitres.
@DataClassName('WaterLogRow')
class WaterLogs extends Table {
  TextColumn get day => text()();
  IntColumn get ml => integer()();

  @override
  Set<Column> get primaryKey => {day};
}
