import 'package:fitness_trakcer/features/activity/domain/entities/activity_source.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_activity.freezed.dart';

/// Movement totals for one calendar day.
@freezed
abstract class DailyActivity with _$DailyActivity {
  const factory DailyActivity({
    /// Start of the day (local time).
    required DateTime date,
    @Default(0) int steps,
    @Default(0) double distanceMeters,
    @Default(0) double activeCaloriesKcal,
    @Default(ActivitySource.manual) ActivitySource source,
  }) = _DailyActivity;
}
