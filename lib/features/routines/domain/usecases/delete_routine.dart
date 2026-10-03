import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/routines/domain/repositories/routine_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DeleteRoutine implements UseCase<void, String> {
  const DeleteRoutine(this._repository);

  final RoutineRepository _repository;

  @override
  Future<Result<void>> call(String params) => _repository.deleteRoutine(params);
}
