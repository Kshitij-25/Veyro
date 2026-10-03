import 'package:fitness_trakcer/core/error/failure_exception.dart';
import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/routines/data/datasources/routine_local_data_source.dart';
import 'package:fitness_trakcer/features/routines/data/mappers/routine_mapper.dart';
import 'package:fitness_trakcer/features/routines/domain/entities/routine.dart';
import 'package:fitness_trakcer/features/routines/domain/repositories/routine_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: RoutineRepository)
class RoutineRepositoryImpl implements RoutineRepository {
  const RoutineRepositoryImpl(this._localDataSource);

  final RoutineLocalDataSource _localDataSource;

  @override
  Stream<List<Routine>> watchRoutines() => _localDataSource.watchAll().map(
    (aggregates) => aggregates.map((a) => a.toEntity()).toList(),
  );

  @override
  Future<Result<List<Routine>>> getRoutines() => guard(() async {
    final aggregates = await _localDataSource.getAll();
    return aggregates.map((a) => a.toEntity()).toList();
  });

  @override
  Future<Result<Routine>> getRoutine(String id) => guard(() async {
    final aggregate = await _localDataSource.getById(id);
    if (aggregate == null) {
      throw const FailureException(NotFoundFailure('Routine not found.'));
    }
    return aggregate.toEntity();
  });

  @override
  Future<Result<void>> saveRoutine(Routine routine) =>
      guard(() => _localDataSource.save(routine));

  @override
  Future<Result<void>> deleteRoutine(String id) =>
      guard(() => _localDataSource.delete(id));
}
