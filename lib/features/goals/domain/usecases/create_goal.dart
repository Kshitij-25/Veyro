import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/clock.dart';
import 'package:fitness_trakcer/core/utils/id_generator.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/usecases/get_latest_weight.dart';
import 'package:fitness_trakcer/features/goals/domain/entities/goal.dart';
import 'package:fitness_trakcer/features/goals/domain/entities/goal_type.dart';
import 'package:fitness_trakcer/features/goals/domain/repositories/goal_repository.dart';
import 'package:injectable/injectable.dart';

class CreateGoalParams {
  const CreateGoalParams({
    required this.type,
    required this.targetValue,
    this.deadline,
  });

  final GoalType type;

  /// In metric base units (see [Goal]).
  final double targetValue;
  final DateTime? deadline;
}

@lazySingleton
class CreateGoal implements UseCase<Goal, CreateGoalParams> {
  const CreateGoal(
    this._repository,
    this._getLatestWeight,
    this._ids,
    this._clock,
  );

  final GoalRepository _repository;
  final GetLatestWeight _getLatestWeight;
  final IdGenerator _ids;
  final Clock _clock;

  @override
  Future<Result<Goal>> call(CreateGoalParams params) async {
    if (params.targetValue <= 0) {
      return const Fail(ValidationFailure('Target must be greater than zero.'));
    }
    final now = _clock.now();
    if (params.deadline != null && params.deadline!.isBefore(now)) {
      return const Fail(
        ValidationFailure('The deadline must be in the future.'),
      );
    }

    final existing = await _repository.getGoals();
    if (existing case Fail(:final failure)) return Fail(failure);
    if (existing.dataOrNull!.any((g) => g.isActive && g.type == params.type)) {
      return const Fail(
        ValidationFailure('You already have an active goal of this type.'),
      );
    }

    final startValue = params.type == GoalType.targetWeight
        ? (await _getLatestWeight(const NoParams())).dataOrNull
        : null;
    final goal = Goal(
      id: _ids.generate(),
      type: params.type,
      targetValue: params.targetValue,
      startValue: startValue,
      startDate: now,
      deadline: params.deadline,
      createdAt: now,
    );
    final saved = await _repository.saveGoal(goal);
    return saved.map((_) => goal);
  }
}
