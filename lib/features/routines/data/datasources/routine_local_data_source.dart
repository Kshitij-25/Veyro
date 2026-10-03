import 'package:drift/drift.dart';
import 'package:fitness_trakcer/core/database/app_database.dart';
import 'package:fitness_trakcer/features/routines/data/mappers/routine_mapper.dart';
import 'package:fitness_trakcer/features/routines/data/models/routine_aggregate.dart';
import 'package:fitness_trakcer/features/routines/domain/entities/routine.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RoutineLocalDataSource {
  const RoutineLocalDataSource(this._db);

  final AppDatabase _db;

  JoinedSelectStatement<HasResultSet, dynamic> _joinedQuery() {
    return _db.select(_db.routines).join([
      leftOuterJoin(
        _db.routineExercises,
        _db.routineExercises.routineId.equalsExp(_db.routines.id),
      ),
      leftOuterJoin(
        _db.exercises,
        _db.exercises.id.equalsExp(_db.routineExercises.exerciseId),
      ),
    ])..orderBy([OrderingTerm.asc(_db.routines.name)]);
  }

  List<RoutineAggregate> _assemble(List<TypedResult> rows) {
    final routines = <String, RoutineRow>{};
    final exercises = <String, List<RoutineExerciseAggregate>>{};
    for (final row in rows) {
      final routine = row.readTable(_db.routines);
      routines[routine.id] = routine;
      final routineExercise = row.readTableOrNull(_db.routineExercises);
      final exercise = row.readTableOrNull(_db.exercises);
      if (routineExercise == null || exercise == null) continue;
      exercises
          .putIfAbsent(routine.id, () => [])
          .add(
            RoutineExerciseAggregate(
              routineExercise: routineExercise,
              exercise: exercise,
            ),
          );
    }
    return [
      for (final routine in routines.values)
        RoutineAggregate(
          routine: routine,
          exercises: [...?exercises[routine.id]]
            ..sort(
              (a, b) => a.routineExercise.position.compareTo(
                b.routineExercise.position,
              ),
            ),
        ),
    ];
  }

  Stream<List<RoutineAggregate>> watchAll() =>
      _joinedQuery().watch().map(_assemble);

  Future<List<RoutineAggregate>> getAll() async =>
      _assemble(await _joinedQuery().get());

  Future<RoutineAggregate?> getById(String id) async {
    final query = _joinedQuery()..where(_db.routines.id.equals(id));
    return _assemble(await query.get()).firstOrNull;
  }

  Future<void> save(Routine routine) {
    return _db.transaction(() async {
      await _db
          .into(_db.routines)
          .insertOnConflictUpdate(routine.toCompanion());
      await (_db.delete(
        _db.routineExercises,
      )..where((t) => t.routineId.equals(routine.id))).go();
      for (final exercise in routine.exercises) {
        await _db
            .into(_db.routineExercises)
            .insert(exercise.toCompanion(routine.id));
      }
    });
  }

  Future<void> delete(String id) =>
      (_db.delete(_db.routines)..where((t) => t.id.equals(id))).go();
}
