import 'package:drift/drift.dart';
import 'package:fitness_trakcer/core/database/tables/workout_tables.dart';

@DataClassName('RoutineRow')
class Routines extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get notes => text().nullable()();

  /// ISO weekdays packed into a bitmask (bit 0 = Monday … bit 6 = Sunday).
  IntColumn get scheduledWeekdaysMask =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('RoutineExerciseRow')
class RoutineExercises extends Table {
  TextColumn get id => text()();
  TextColumn get routineId =>
      text().references(Routines, #id, onDelete: KeyAction.cascade)();
  TextColumn get exerciseId => text().references(Exercises, #id)();
  IntColumn get position => integer()();
  IntColumn get targetSets => integer()();
  IntColumn get targetReps => integer()();
  RealColumn get targetWeightKg => real().nullable()();
  IntColumn get restSeconds => integer().withDefault(const Constant(90))();

  @override
  Set<Column> get primaryKey => {id};
}
