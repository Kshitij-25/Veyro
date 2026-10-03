import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/routines/domain/entities/routine.dart';

abstract interface class RoutineRepository {
  /// Alphabetical.
  Stream<List<Routine>> watchRoutines();

  Future<Result<List<Routine>>> getRoutines();

  Future<Result<Routine>> getRoutine(String id);

  Future<Result<void>> saveRoutine(Routine routine);

  Future<Result<void>> deleteRoutine(String id);
}
