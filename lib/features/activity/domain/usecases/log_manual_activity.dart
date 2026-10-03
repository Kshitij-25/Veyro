import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/extensions/date_time_extensions.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/activity/domain/entities/activity_source.dart';
import 'package:fitness_trakcer/features/activity/domain/entities/daily_activity.dart';
import 'package:fitness_trakcer/features/activity/domain/repositories/activity_repository.dart';
import 'package:injectable/injectable.dart';

class LogManualActivityParams {
  const LogManualActivityParams({
    required this.date,
    required this.steps,
    this.distanceMeters = 0,
    this.activeCaloriesKcal = 0,
  });

  final DateTime date;
  final int steps;
  final double distanceMeters;
  final double activeCaloriesKcal;
}

/// Sets the totals for a day by hand (for devices without a health store).
@lazySingleton
class LogManualActivity implements UseCase<void, LogManualActivityParams> {
  const LogManualActivity(this._repository);

  final ActivityRepository _repository;

  @override
  Future<Result<void>> call(LogManualActivityParams params) {
    if (params.steps < 0 ||
        params.distanceMeters < 0 ||
        params.activeCaloriesKcal < 0) {
      return Future.value(
        const Fail(ValidationFailure('Values cannot be negative.')),
      );
    }
    return _repository.saveDay(
      DailyActivity(
        date: params.date.startOfDay,
        steps: params.steps,
        distanceMeters: params.distanceMeters,
        activeCaloriesKcal: params.activeCaloriesKcal,
        source: ActivitySource.manual,
      ),
    );
  }
}
