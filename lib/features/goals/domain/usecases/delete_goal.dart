import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/goals/domain/repositories/goal_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DeleteGoal implements UseCase<void, String> {
  const DeleteGoal(this._repository);

  final GoalRepository _repository;

  @override
  Future<Result<void>> call(String params) => _repository.deleteGoal(params);
}
