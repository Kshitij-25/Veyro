import 'package:drift/drift.dart';

@DataClassName('CheckInRow')
class ProgressCheckIns extends Table {
  TextColumn get id => text()();
  DateTimeColumn get takenAt => dateTime()();

  /// Body weight when the check-in was created, if one was logged.
  RealColumn get weightKg => real().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// One photo per angle (`front`, `side`, `back`) per check-in. [fileName] is
/// relative to the app's photo folder because absolute paths can change
/// between app updates.
@DataClassName('CheckInPhotoRow')
class ProgressPhotos extends Table {
  TextColumn get checkInId =>
      text().references(ProgressCheckIns, #id, onDelete: KeyAction.cascade)();
  TextColumn get angle => text()();
  TextColumn get fileName => text()();

  @override
  Set<Column> get primaryKey => {checkInId, angle};
}
