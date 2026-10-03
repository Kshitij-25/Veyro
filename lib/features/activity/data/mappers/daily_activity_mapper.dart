import 'package:drift/drift.dart';
import 'package:fitness_trakcer/core/database/app_database.dart';
import 'package:fitness_trakcer/core/extensions/date_time_extensions.dart';
import 'package:fitness_trakcer/features/activity/data/models/health_day_summary.dart';
import 'package:fitness_trakcer/features/activity/domain/entities/activity_source.dart';
import 'package:fitness_trakcer/features/activity/domain/entities/daily_activity.dart';

extension DailyActivityRowMapper on DailyActivityRow {
  DailyActivity toEntity() => DailyActivity(
    date: DateTimeX.fromDayKey(dayKey),
    steps: steps,
    distanceMeters: distanceMeters,
    activeCaloriesKcal: activeCaloriesKcal,
    source: ActivitySource.values.byName(source),
  );
}

extension DailyActivityEntityMapper on DailyActivity {
  DailyActivitiesCompanion toCompanion(DateTime updatedAt) =>
      DailyActivitiesCompanion(
        dayKey: Value(date.dayKey),
        steps: Value(steps),
        distanceMeters: Value(distanceMeters),
        activeCaloriesKcal: Value(activeCaloriesKcal),
        source: Value(source.name),
        updatedAt: Value(updatedAt),
      );
}

extension HealthDaySummaryMapper on HealthDaySummary {
  DailyActivity toEntity() => DailyActivity(
    date: date,
    steps: steps,
    distanceMeters: distanceMeters,
    activeCaloriesKcal: activeCaloriesKcal,
    source: ActivitySource.health,
  );
}
