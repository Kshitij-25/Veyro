import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:fitness_trakcer/core/database/app_database.dart';
import 'package:fitness_trakcer/core/error/failure_exception.dart';
import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/utils/clock.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/data_management/domain/repositories/data_management_repository.dart';
import 'package:fitness_trakcer/features/progress_photos/data/services/photo_file_store.dart';
import 'package:fitness_trakcer/features/reminders/domain/services/reminder_scheduler.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

@LazySingleton(as: DataManagementRepository)
class DataManagementRepositoryImpl implements DataManagementRepository {
  const DataManagementRepositoryImpl(
    this._db,
    this._photos,
    this._scheduler,
    this._clock,
  );

  final AppDatabase _db;
  final PhotoFileStore _photos;
  final ReminderScheduler _scheduler;
  final Clock _clock;

  static const _serializer = ValueSerializer.defaults(
    serializeDateTimeValuesAsString: true,
  );

  @override
  Future<Result<String>> exportToFile() => guard(() async {
    final tables = <String, List<Map<String, dynamic>>>{};
    for (final table in _db.allTables) {
      final name = table.actualTableName;
      final rows = <Map<String, dynamic>>[];
      for (final row in await _db.select(table).get()) {
        final json = (row as DataClass).toJson(serializer: _serializer);
        // The built-in and downloaded exercise library isn't user data.
        if (name == 'exercises' && json['source'] != 'custom') continue;
        rows.add(json);
      }
      tables[name] = rows;
    }
    final now = _clock.now();
    final document = {
      'app': 'Veyro',
      'exportedAt': now.toIso8601String(),
      'databaseVersion': _db.schemaVersion,
      'note': 'Progress photos are not included in this file; they stay on the device.',
      'tables': tables,
    };
    final dir = await getTemporaryDirectory();
    final stamp =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final file = File(p.join(dir.path, 'veyro_export_$stamp.json'));
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(document),
    );
    return file.path;
  });

  @override
  Future<Result<void>> deleteEverything() => guard(() async {
    await _scheduler.cancelAll();
    await _db.transaction(_wipe);
    await _photos.deleteAll();
  });

  /// Clears all user data inside the caller's transaction.
  Future<void> _wipe() async {
    // Rows reference each other; check constraints at commit instead.
    await _db.customStatement('PRAGMA defer_foreign_keys = ON');
    for (final table in _db.allTables) {
      if (table.actualTableName == 'exercises') continue;
      await _db.delete(table).go();
    }
    await (_db.delete(
      _db.exercises,
    )..where((t) => t.source.equals('custom'))).go();
  }

  @override
  Future<Result<int>> restoreFromFile(String path) => guard(() async {
    final Object? decoded;
    try {
      decoded = jsonDecode(await File(path).readAsString());
    } on FormatException {
      throw const FailureException(
        ValidationFailure('That isn\'t a Veyro export file.'),
      );
    }
    if (decoded is! Map<String, dynamic> ||
        decoded['app'] != 'Veyro' ||
        decoded['tables'] is! Map<String, dynamic>) {
      throw const FailureException(
        ValidationFailure('That isn\'t a Veyro export file.'),
      );
    }
    final version = decoded['databaseVersion'];
    if (version is! int || version > _db.schemaVersion) {
      throw const FailureException(
        ValidationFailure('That file was made by a newer version of the app.'),
      );
    }
    final data = decoded['tables'] as Map<String, dynamic>;
    var count = 0;
    await _scheduler.cancelAll();
    await _db.transaction(() async {
      await _wipe();
      for (final table in _db.allTables) {
        final name = table.actualTableName;
        // Photo files are never exported, so their rows would dangle.
        if (name == 'progress_photos') continue;
        final rows = data[name];
        if (rows is! List) continue;
        for (final row in rows) {
          if (row is! Map<String, dynamic>) continue;
          final values = <String, Variable>{};
          for (final column in table.$columns) {
            final key = _jsonKey(column.name);
            if (!row.containsKey(key)) continue;
            values[column.name] = _variable(column.type, row[key]);
          }
          if (values.isEmpty) continue;
          await _db.customInsert(
            'INSERT OR REPLACE INTO "$name" '
            '(${values.keys.map((c) => '"$c"').join(', ')}) '
            'VALUES (${List.filled(values.length, '?').join(', ')})',
            variables: values.values.cast<Variable>().toList(),
            updates: {table},
          );
          count++;
        }
      }
    });
    return count;
  });

  /// `heart_rate` -> `heartRate`, the key the exporter wrote.
  static String _jsonKey(String column) {
    final parts = column.split('_');
    return parts.first +
        parts
            .skip(1)
            .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
            .join();
  }

  static Variable _variable(Object type, Object? value) {
    if (value == null) return const Variable<Object>(null);
    if (type == DriftSqlType.dateTime) {
      return Variable<DateTime>(DateTime.parse(value as String));
    }
    if (type == DriftSqlType.bool) return Variable<bool>(value as bool);
    if (type == DriftSqlType.int) {
      return Variable<int>((value as num).toInt());
    }
    if (type == DriftSqlType.double) {
      return Variable<double>((value as num).toDouble());
    }
    return Variable<String>(value.toString());
  }
}
