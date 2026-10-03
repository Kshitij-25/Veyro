import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/routines/domain/entities/routine.dart';
import 'package:fitness_trakcer/features/routines/domain/repositories/routine_repository.dart';
import 'package:injectable/injectable.dart';

/// Routines planned for the weekday of the given date.
@lazySingleton
class GetRoutinesForDate implements UseCase<List<Routine>, DateTime> {
  const GetRoutinesForDate(this._repository);

  final RoutineRepository _repository;

  @override
  Future<Result<List<Routine>>> call(DateTime params) async {
    final routines = await _repository.getRoutines();
    return routines.map(
      (all) => [
        for (final routine in all)
          if (routine.isScheduledOn(params)) routine,
      ],
    );
  }
}
