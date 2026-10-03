import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/features/routines/domain/entities/routine.dart';
import 'package:fitness_trakcer/features/routines/domain/repositories/routine_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class WatchRoutines implements StreamUseCase<List<Routine>, NoParams> {
  const WatchRoutines(this._repository);

  final RoutineRepository _repository;

  @override
  Stream<List<Routine>> call(NoParams params) => _repository.watchRoutines();
}
