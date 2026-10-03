import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/goals/domain/entities/goal.dart';

abstract interface class GoalRepository {
  Stream<List<Goal>> watchGoals();

  Future<Result<List<Goal>>> getGoals();

  Future<Result<void>> saveGoal(Goal goal);

  Future<Result<void>> deleteGoal(String id);
}
