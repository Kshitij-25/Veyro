import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:fitness_trakcer/core/database/app_database.dart';
import 'package:injectable/injectable.dart';

Future<void> closeAppDatabase(AppDatabase database) => database.close();

@module
abstract class DatabaseModule {
  @Singleton(dispose: closeAppDatabase)
  AppDatabase get database => AppDatabase(_openConnection());
}

QueryExecutor _openConnection() => driftDatabase(
  name: 'fitness_tracker',
  // Web needs these two assets next to index.html. See README.
  web: DriftWebOptions(
    sqlite3Wasm: Uri.parse('sqlite3.wasm'),
    driftWorker: Uri.parse('drift_worker.js'),
  ),
);
