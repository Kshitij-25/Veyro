import 'package:fitness_trakcer/core/extensions/date_time_extensions.dart';

/// A half-open interval `[start, end)` of local time.
class DateRange {
  const DateRange(this.start, this.end);

  /// The whole calendar day containing [date].
  factory DateRange.day(DateTime date) =>
      DateRange(date.startOfDay, date.nextDay);

  /// The Monday-based calendar week containing [date].
  factory DateRange.week(DateTime date) {
    final start = date.startOfWeek;
    return DateRange(start, DateTime(start.year, start.month, start.day + 7));
  }

  /// The [days] calendar days ending with (and including) the day of [until].
  factory DateRange.lastDays(int days, {required DateTime until}) {
    final end = until.nextDay;
    return DateRange(DateTime(end.year, end.month, end.day - days), end);
  }

  final DateTime start;
  final DateTime end;

  bool contains(DateTime value) =>
      !value.isBefore(start) && value.isBefore(end);

  /// Start-of-day for every day inside the range.
  Iterable<DateTime> get days sync* {
    var cursor = start.startOfDay;
    while (cursor.isBefore(end)) {
      yield cursor;
      cursor = DateTime(cursor.year, cursor.month, cursor.day + 1);
    }
  }
}
