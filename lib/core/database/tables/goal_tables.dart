import 'package:drift/drift.dart';

@DataClassName('GoalRow')
class Goals extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  RealColumn get targetValue => real()();

  /// Baseline captured when the goal was created (used by "target weight").
  RealColumn get startValue => real().nullable()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get deadline => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('UnlockedAchievementRow')
class UnlockedAchievements extends Table {
  TextColumn get achievementId => text()();
  DateTimeColumn get unlockedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {achievementId};
}
