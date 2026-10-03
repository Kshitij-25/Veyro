import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/clock.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/workout/domain/entities/exercise_sync_result.dart';
import 'package:fitness_trakcer/features/workout/domain/repositories/exercise_repository.dart';
import 'package:injectable/injectable.dart';

class SyncRemoteExercisesParams {
  const SyncRemoteExercisesParams({this.force = false});

  /// Re-download even if the catalogue was imported recently.
  final bool force;
}

/// Imports the wger catalogue. Without [SyncRemoteExercisesParams.force] it
/// only runs when the last import is missing or older than [maxAge].
@lazySingleton
class SyncRemoteExercises
    implements UseCase<ExerciseSyncResult, SyncRemoteExercisesParams> {
  const SyncRemoteExercises(this._repository, this._clock);

  static const maxAge = Duration(days: 30);

  final ExerciseRepository _repository;
  final Clock _clock;

  @override
  Future<Result<ExerciseSyncResult>> call(
    SyncRemoteExercisesParams params,
  ) async {
    if (!params.force) {
      final last = (await _repository.getLastRemoteSync()).dataOrNull;
      if (last != null && _clock.now().difference(last) < maxAge) {
        return const Success(ExerciseSyncResult.upToDate());
      }
    }
    return _repository.syncRemoteExercises();
  }
}
