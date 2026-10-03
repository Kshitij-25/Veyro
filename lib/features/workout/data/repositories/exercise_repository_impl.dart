import 'package:fitness_trakcer/core/error/failure_exception.dart';
import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/utils/clock.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/workout/data/datasources/exercise_local_data_source.dart';
import 'package:fitness_trakcer/features/workout/data/datasources/metadata_local_data_source.dart';
import 'package:fitness_trakcer/features/workout/data/datasources/wger_remote_data_source.dart';
import 'package:fitness_trakcer/features/workout/data/mappers/exercise_mapper.dart';
import 'package:fitness_trakcer/features/workout/data/mappers/wger_exercise_mapper.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise_source.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise_sync_result.dart';
import 'package:fitness_trakcer/features/workout/domain/repositories/exercise_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ExerciseRepository)
class ExerciseRepositoryImpl implements ExerciseRepository {
  const ExerciseRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
    this._metadata,
    this._clock,
  );

  final ExerciseLocalDataSource _localDataSource;
  final WgerRemoteDataSource _remoteDataSource;
  final MetadataLocalDataSource _metadata;
  final Clock _clock;

  @override
  Stream<List<Exercise>> watchExercises() => _localDataSource.watchAll().map(
    (rows) => rows.map((row) => row.toEntity()).toList(),
  );

  @override
  Future<Result<Exercise>> getExercise(String id) => guard(() async {
    final row = await _localDataSource.getById(id);
    if (row == null) {
      throw const FailureException(NotFoundFailure('Exercise not found.'));
    }
    return row.toEntity();
  });

  @override
  Future<Result<void>> saveExercise(Exercise exercise) =>
      guard(() => _localDataSource.upsert(exercise.toCompanion()));

  @override
  Future<Result<void>> deleteExercise(String id) => guard(() async {
    try {
      await _localDataSource.delete(id);
    } catch (_) {
      throw const FailureException(
        DatabaseFailure('This exercise is used in your workouts.'),
      );
    }
  });

  @override
  Future<Result<ExerciseSyncResult>> syncRemoteExercises() => guard(() async {
    final remote = await _remoteDataSource.fetchAll();
    final existing = await _localDataSource.getAll();

    String normalize(String name) => name.trim().toLowerCase();
    // Names owned by built-in or custom exercises; remote copies are skipped.
    final localNames = {
      for (final row in existing)
        if (row.source != ExerciseSource.wger.name) normalize(row.name),
    };
    final importedIds = {
      for (final row in existing)
        if (row.source == ExerciseSource.wger.name) row.id,
    };

    final seenNames = <String>{};
    final imports = <Exercise>[];
    var added = 0;
    var updated = 0;
    var skipped = 0;
    for (final dto in remote) {
      final exercise = dto.toExercise();
      final key = exercise == null ? '' : normalize(exercise.name);
      if (exercise == null || localNames.contains(key) || !seenNames.add(key)) {
        skipped++;
        continue;
      }
      importedIds.contains(exercise.id) ? updated++ : added++;
      imports.add(exercise);
    }

    await _localDataSource.upsertAll(imports);
    await _metadata.set(
      MetadataLocalDataSource.wgerLastSyncKey,
      _clock.now().toIso8601String(),
    );
    return ExerciseSyncResult(added: added, updated: updated, skipped: skipped);
  });

  @override
  Future<Result<DateTime?>> getLastRemoteSync() => guard(() async {
    final value = await _metadata.get(MetadataLocalDataSource.wgerLastSyncKey);
    return value == null ? null : DateTime.tryParse(value);
  });
}
