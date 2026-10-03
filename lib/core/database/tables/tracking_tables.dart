import 'package:drift/drift.dart';

@DataClassName('TrackedActivityRow')
class TrackedActivities extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime()();
  IntColumn get movingSeconds => integer()();
  RealColumn get distanceMeters => real()();
  RealColumn get elevationGainMeters => real().withDefault(const Constant(0))();
  RealColumn get caloriesKcal => real().withDefault(const Constant(0))();

  /// The recorded GPS route serialised as a JSON array of points.
  TextColumn get routeJson => text().withDefault(const Constant('[]'))();

  @override
  Set<Column> get primaryKey => {id};
}
