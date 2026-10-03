import 'package:fitness_trakcer/core/extensions/date_time_extensions.dart';
import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/features/activity/domain/entities/daily_activity.dart';
import 'package:fitness_trakcer/features/activity/domain/repositories/activity_repository.dart';
import 'package:injectable/injectable.dart';

/// Activity for a day; an empty [DailyActivity] when nothing is recorded.
@lazySingleton
class WatchDailyActivity implements StreamUseCase<DailyActivity, DateTime> {
  const WatchDailyActivity(this._repository);

  final ActivityRepository _repository;

  @override
  Stream<DailyActivity> call(DateTime params) => _repository
      .watchDay(params)
      .map((activity) => activity ?? DailyActivity(date: params.startOfDay));
}
