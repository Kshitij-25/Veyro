import 'package:drift/drift.dart';
import 'package:fitness_trakcer/core/database/app_database.dart';
import 'package:fitness_trakcer/features/workout/data/mappers/exercise_mapper.dart';
import 'package:fitness_trakcer/features/workout/data/seed/default_exercises.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ExerciseLocalDataSource {
  const ExerciseLocalDataSource(this._db);

  final AppDatabase _db;

  Stream<List<ExerciseRow>> watchAll() {
    final query = _db.select(_db.exercises)
      ..orderBy([(t) => OrderingTerm.asc(t.name)]);
    return query.watch();
  }

  Future<ExerciseRow?> getById(String id) => (_db.select(
    _db.exercises,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<ExerciseRow>> getAll() => _db.select(_db.exercises).get();

  /// Inserts new rows and refreshes existing ones (matched by primary key).
  Future<void> upsertAll(List<Exercise> exercises) => _db.batch(
    (batch) => batch.insertAllOnConflictUpdate(_db.exercises, [
      for (final exercise in exercises) exercise.toCompanion(),
    ]),
  );

  Future<void> upsert(ExercisesCompanion exercise) =>
      _db.into(_db.exercises).insertOnConflictUpdate(exercise);

  Future<void> delete(String id) =>
      (_db.delete(_db.exercises)
            ..where((t) => t.id.equals(id))
            ..where((t) => t.isCustom.equals(true)))
          .go();

  /// Inserts the built-in exercise library on first launch.
  Future<void> seedIfEmpty() async {
    final count = _db.exercises.id.count();
    final query = _db.selectOnly(_db.exercises)..addColumns([count]);
    final existing = await query.map((row) => row.read(count)).getSingle();
    if ((existing ?? 0) > 0) return;
    await _db.batch((batch) {
      batch.insertAll(_db.exercises, [
        for (final exercise in defaultExercises) exercise.toCompanion(),
      ], mode: InsertMode.insertOrIgnore);
    });
  }
}
