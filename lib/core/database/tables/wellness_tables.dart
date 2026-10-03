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

/// One fast. A row with no [endedAt] is the fast in progress.
@DataClassName('FastRow')
class FastingSessions extends Table {
  TextColumn get id => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  IntColumn get goalHours => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// A finished (or ended-early) mind or breathing session.
@DataClassName('MindRow')
class MindSessions extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get category => text()();
  DateTimeColumn get startedAt => dateTime()();
  IntColumn get seconds => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Foods the user logged, starred or created. Search results from the online
/// databases are only stored once used. [id] looks like `off:<barcode>`,
/// `usda:<fdcId>` or `custom:<uuid>`; nutrition is per [servingLabel].
@DataClassName('SavedFoodRow')
class SavedFoods extends Table {
  TextColumn get id => text()();
  TextColumn get source => text()();
  TextColumn get name => text()();
  TextColumn get brand => text().nullable()();
  TextColumn get servingLabel => text()();
  RealColumn get kcal => real()();
  RealColumn get protein => real()();
  RealColumn get carbs => real()();
  RealColumn get fat => real()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastUsedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Sleep, HRV and resting heart rate per day, imported from Health. [day] is
/// `yyyy-MM-dd`; for sleep it is the day the night ended on.
@DataClassName('RecoveryHistoryRow')
class RecoveryHistory extends Table {
  TextColumn get day => text()();
  IntColumn get asleepMinutes => integer().nullable()();
  IntColumn get awakeMinutes => integer().nullable()();
  IntColumn get remMinutes => integer().nullable()();
  IntColumn get lightMinutes => integer().nullable()();
  IntColumn get deepMinutes => integer().nullable()();
  DateTimeColumn get bedtime => dateTime().nullable()();
  DateTimeColumn get wakeTime => dateTime().nullable()();
  RealColumn get hrvMs => real().nullable()();
  RealColumn get restingHr => real().nullable()();

  @override
  Set<Column> get primaryKey => {day};
}
