import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise_sync_result.dart';

abstract interface class ExerciseRepository {
  /// Alphabetical; includes the built-in library and custom exercises.
  Stream<List<Exercise>> watchExercises();

  Future<Result<Exercise>> getExercise(String id);

  Future<Result<void>> saveExercise(Exercise exercise);

  Future<Result<void>> deleteExercise(String id);

  /// Downloads the wger exercise catalogue and merges it into the library.
  /// Exercises whose name already exists are left untouched.
  Future<Result<ExerciseSyncResult>> syncRemoteExercises();

  /// When the remote catalogue was last imported, if ever.
  Future<Result<DateTime?>> getLastRemoteSync();
}
