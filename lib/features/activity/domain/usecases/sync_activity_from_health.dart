import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/activity/domain/repositories/activity_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SyncActivityFromHealth implements UseCase<void, DateRange> {
  const SyncActivityFromHealth(this._repository);

  final ActivityRepository _repository;

  @override
  Future<Result<void>> call(DateRange params) =>
      _repository.syncFromHealth(params);
}
