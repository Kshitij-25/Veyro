import 'package:fitness_trakcer/core/usecase/use_case.dart';
import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/activity/domain/entities/daily_activity.dart';
import 'package:fitness_trakcer/features/activity/domain/repositories/activity_repository.dart';
import 'package:injectable/injectable.dart';

/// One entry for every day in the range, with zeroes for days without data.
@lazySingleton
class GetActivityRange implements UseCase<List<DailyActivity>, DateRange> {
  const GetActivityRange(this._repository);

  final ActivityRepository _repository;

  @override
  Future<Result<List<DailyActivity>>> call(DateRange params) async {
    final stored = await _repository.getRange(params);
    return stored.map((days) {
      final byDay = {for (final d in days) d.date: d};
      return [
        for (final day in params.days) byDay[day] ?? DailyActivity(date: day),
      ];
    });
  }
}
