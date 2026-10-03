import 'package:drift/drift.dart';
import 'package:fitness_trakcer/core/database/app_database.dart';
import 'package:fitness_trakcer/core/error/failure_exception.dart';
import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:fitness_trakcer/features/workout/data/mappers/workout_mapper.dart';
import 'package:fitness_trakcer/features/workout/data/models/workout_aggregate.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/workout.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class WorkoutLocalDataSource {
  const WorkoutLocalDataSource(this._db);

  final AppDatabase _db;

  /// Workouts joined with their exercises and sets. Reads from every involved
  /// table, so streams re-emit when any of them change.
  JoinedSelectStatement<HasResultSet, dynamic> _joinedQuery() {
    return _db.select(_db.workouts).join([
      leftOuterJoin(
        _db.workoutExercises,
        _db.workoutExercises.workoutId.equalsExp(_db.workouts.id),
      ),
      leftOuterJoin(
        _db.exercises,
        _db.exercises.id.equalsExp(_db.workoutExercises.exerciseId),
      ),
      leftOuterJoin(
        _db.workoutSets,
        _db.workoutSets.workoutExerciseId.equalsExp(_db.workoutExercises.id),
      ),
    ]);
  }

  List<WorkoutAggregate> _assemble(List<TypedResult> rows) {
    final workouts = <String, WorkoutRow>{};
    final exercisesByWorkout =
        <String, Map<String, WorkoutExerciseAggregate>>{};
    final setsByExercise = <String, List<WorkoutSetRow>>{};

    for (final row in rows) {
      final workout = row.readTable(_db.workouts);
      workouts[workout.id] = workout;
      final workoutExercise = row.readTableOrNull(_db.workoutExercises);
      final exercise = row.readTableOrNull(_db.exercises);
      if (workoutExercise == null || exercise == null) continue;

      final sets = setsByExercise.putIfAbsent(workoutExercise.id, () => []);
      exercisesByWorkout
          .putIfAbsent(workout.id, () => {})
          .putIfAbsent(
            workoutExercise.id,
            () => WorkoutExerciseAggregate(
              workoutExercise: workoutExercise,
              exercise: exercise,
              sets: sets,
            ),
          );
      final set = row.readTableOrNull(_db.workoutSets);
      if (set != null) sets.add(set);
    }

    return [
      for (final workout in workouts.values)
        WorkoutAggregate(
          workout: workout,
          exercises: [...?exercisesByWorkout[workout.id]?.values]
            ..sort(
              (a, b) => a.workoutExercise.position.compareTo(
                b.workoutExercise.position,
              ),
            ),
        ),
    ];
  }

  void _sortSets(List<WorkoutAggregate> aggregates) {
    for (final aggregate in aggregates) {
      for (final exercise in aggregate.exercises) {
        exercise.sets.sort((a, b) => a.position.compareTo(b.position));
      }
    }
  }

  List<WorkoutAggregate> _finish(List<TypedResult> rows) {
    final aggregates = _assemble(rows);
    _sortSets(aggregates);
    return aggregates;
  }

  Stream<List<WorkoutAggregate>> watchCompleted() {
    final query = _joinedQuery()
      ..where(_db.workouts.endedAt.isNotNull())
      ..orderBy([OrderingTerm.desc(_db.workouts.startedAt)]);
    return query.watch().map(_finish);
  }

  Stream<WorkoutAggregate?> watchActive() {
    final query = _joinedQuery()..where(_db.workouts.endedAt.isNull());
    return query.watch().map((rows) => _finish(rows).firstOrNull);
  }

  Future<WorkoutAggregate?> getActive() async {
    final query = _joinedQuery()..where(_db.workouts.endedAt.isNull());
    return _finish(await query.get()).firstOrNull;
  }

  Future<WorkoutAggregate?> getById(String id) async {
    final query = _joinedQuery()..where(_db.workouts.id.equals(id));
    return _finish(await query.get()).firstOrNull;
  }

  Future<List<WorkoutAggregate>> getCompleted(DateRange range) async {
    final query = _joinedQuery()
      ..where(_db.workouts.endedAt.isNotNull())
      ..where(_db.workouts.startedAt.isBiggerOrEqualValue(range.start))
      ..where(_db.workouts.startedAt.isSmallerThanValue(range.end))
      ..orderBy([OrderingTerm.asc(_db.workouts.startedAt)]);
    return _finish(await query.get());
  }

  Future<int> countCompleted() async {
    final count = _db.workouts.id.count();
    final query = _db.selectOnly(_db.workouts)
      ..addColumns([count])
      ..where(_db.workouts.endedAt.isNotNull());
    return (await query.map((row) => row.read(count)).getSingle()) ?? 0;
  }

  Future<void> saveWorkout(Workout workout) =>
      _db.transaction(() => _writeWorkout(workout));

  /// Reads, transforms and writes a workout inside a single transaction.
  Future<Workout> updateWorkout(
    String id,
    Workout Function(Workout current) transform,
  ) {
    return _db.transaction(() async {
      final current = await getById(id);
      if (current == null) {
        throw const FailureException(NotFoundFailure('Workout not found.'));
      }
      final updated = transform(current.toEntity());
      await _writeWorkout(updated);
      return updated;
    });
  }

  Future<void> _writeWorkout(Workout workout) async {
    await _db.into(_db.workouts).insertOnConflictUpdate(workout.toCompanion());
    // Cascades remove the old sets as well.
    await (_db.delete(
      _db.workoutExercises,
    )..where((t) => t.workoutId.equals(workout.id))).go();
    for (final exercise in workout.exercises) {
      await _db
          .into(_db.workoutExercises)
          .insert(exercise.toCompanion(workout.id));
      for (final set in exercise.sets) {
        await _db.into(_db.workoutSets).insert(set.toCompanion(exercise.id));
      }
    }
  }

  Future<void> deleteWorkout(String id) =>
      (_db.delete(_db.workouts)..where((t) => t.id.equals(id))).go();
}
