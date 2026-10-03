import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/health_sync/domain/entities/health_sync_report.dart';
import 'package:fitness_trakcer/features/health_sync/domain/repositories/health_sync_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SyncHealthData implements UseCase<HealthSyncReport, int> {
  const SyncHealthData(this._repository);

  final HealthSyncRepository _repository;

  /// [params] is the number of days to import.
  @override
  Future<Result<HealthSyncReport>> call(int params) =>
      _repository.sync(days: params);
}
