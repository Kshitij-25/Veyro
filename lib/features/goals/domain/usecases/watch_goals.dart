import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/features/goals/domain/entities/goal.dart';
import 'package:fitness_trakcer/features/goals/domain/repositories/goal_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class WatchGoals implements StreamUseCase<List<Goal>, NoParams> {
  const WatchGoals(this._repository);

  final GoalRepository _repository;

  @override
  Stream<List<Goal>> call(NoParams params) => _repository.watchGoals();
}
