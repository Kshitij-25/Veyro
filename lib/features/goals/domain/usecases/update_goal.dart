import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/goals/domain/entities/goal.dart';
import 'package:fitness_trakcer/features/goals/domain/repositories/goal_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UpdateGoal implements UseCase<void, Goal> {
  const UpdateGoal(this._repository);

  final GoalRepository _repository;

  @override
  Future<Result<void>> call(Goal params) {
    if (params.targetValue <= 0) {
      return Future.value(
        const Fail(ValidationFailure('Target must be greater than zero.')),
      );
    }
    return _repository.saveGoal(params);
  }
}
