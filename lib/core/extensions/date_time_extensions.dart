extension DateTimeX on DateTime {
  DateTime get startOfDay => DateTime(year, month, day);

  /// Start of the following calendar day (DST-safe, unlike `+ 24h`).
  DateTime get nextDay => DateTime(year, month, day + 1);

  /// Monday 00:00 of the week containing this date.
  DateTime get startOfWeek => DateTime(year, month, day - (weekday - 1));

  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  /// Compact, sortable integer for the calendar day, e.g. `20261002`.
  int get dayKey => year * 10000 + month * 100 + day;

  static DateTime fromDayKey(int key) =>
      DateTime(key ~/ 10000, (key ~/ 100) % 100, key % 100);
}

extension WeekdayMask on Set<int> {
  /// Packs ISO weekdays (1 = Monday … 7 = Sunday) into a bitmask.
  int toWeekdayMask() => fold(0, (mask, day) => mask | (1 << (day - 1)));
}

extension WeekdayMaskX on int {
  Set<int> toWeekdaySet() => {
    for (var day = 1; day <= 7; day++)
      if (this & (1 << (day - 1)) != 0) day,
  };
}
