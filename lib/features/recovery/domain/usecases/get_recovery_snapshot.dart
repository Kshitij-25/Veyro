import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/clock.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/recovery/domain/entities/recovery_snapshot.dart';
import 'package:fitness_trakcer/features/recovery/domain/repositories/recovery_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetRecoverySnapshot implements UseCase<RecoverySnapshot, NoParams> {
  const GetRecoverySnapshot(this._repository, this._clock);

  final RecoveryRepository _repository;
  final Clock _clock;

  @override
  Future<Result<RecoverySnapshot>> call(NoParams params) =>
      _repository.getSnapshot(now: _clock.now(), days: 15);
}
