import 'package:drift/drift.dart';

/// Small key/value store for app bookkeeping (e.g. when a catalogue was last
/// synced).
@DataClassName('AppMetadataRow')
class AppMetadata extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
