import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/goals/data/datasources/goal_local_data_source.dart';
import 'package:fitness_trakcer/features/goals/data/mappers/goal_mapper.dart';
import 'package:fitness_trakcer/features/goals/domain/entities/goal.dart';
import 'package:fitness_trakcer/features/goals/domain/repositories/goal_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: GoalRepository)
class GoalRepositoryImpl implements GoalRepository {
  const GoalRepositoryImpl(this._localDataSource);

  final GoalLocalDataSource _localDataSource;

  @override
  Stream<List<Goal>> watchGoals() => _localDataSource.watchAll().map(
    (rows) => rows.map((row) => row.toEntity()).toList(),
  );

  @override
  Future<Result<List<Goal>>> getGoals() => guard(() async {
    final rows = await _localDataSource.getAll();
    return rows.map((row) => row.toEntity()).toList();
  });

  @override
  Future<Result<void>> saveGoal(Goal goal) =>
      guard(() => _localDataSource.upsert(goal.toCompanion()));

  @override
  Future<Result<void>> deleteGoal(String id) =>
      guard(() => _localDataSource.delete(id));
}
