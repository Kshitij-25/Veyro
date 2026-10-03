import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/clock.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/sleep/domain/entities/sleep_night.dart';
import 'package:fitness_trakcer/features/sleep/domain/repositories/sleep_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetSleepNights implements UseCase<List<SleepNight>, int> {
  const GetSleepNights(this._repository, this._clock);

  final SleepRepository _repository;
  final Clock _clock;

  /// [params] is how many nights back to read.
  @override
  Future<Result<List<SleepNight>>> call(int params) =>
      _repository.getNights(now: _clock.now(), days: params);
}
