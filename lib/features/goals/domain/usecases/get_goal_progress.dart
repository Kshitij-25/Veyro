import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/goals/domain/entities/goal_progress.dart';
import 'package:fitness_trakcer/features/goals/domain/repositories/goal_repository.dart';
import 'package:fitness_trakcer/features/goals/domain/services/goal_progress_calculator.dart';
import 'package:injectable/injectable.dart';

/// Progress and streaks for every active goal.
@lazySingleton
class GetGoalProgress implements UseCase<List<GoalProgress>, NoParams> {
  const GetGoalProgress(this._repository, this._calculator);

  final GoalRepository _repository;
  final GoalProgressCalculator _calculator;

  @override
  Future<Result<List<GoalProgress>>> call(NoParams params) async {
    final goals = await _repository.getGoals();
    if (goals case Fail(:final failure)) return Fail(failure);
    return guard(
      () async => [
        for (final goal in goals.dataOrNull!)
          if (goal.isActive) await _calculator.calculate(goal),
      ],
    );
  }
}
