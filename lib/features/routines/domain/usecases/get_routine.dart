import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/routines/domain/entities/routine.dart';
import 'package:fitness_trakcer/features/routines/domain/repositories/routine_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetRoutine implements UseCase<Routine, String> {
  const GetRoutine(this._repository);

  final RoutineRepository _repository;

  @override
  Future<Result<Routine>> call(String params) => _repository.getRoutine(params);
}
