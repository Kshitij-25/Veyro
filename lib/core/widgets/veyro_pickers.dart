import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool _isApple(BuildContext context) {
  final platform = Theme.of(context).platform;
  return platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;
}

/// Date picker that follows the platform: a wheel sheet on iOS, the Material
/// calendar dialog elsewhere.
Future<DateTime?> showAdaptiveDatePicker(
  BuildContext context, {
  required DateTime initial,
  required DateTime first,
  required DateTime last,
}) {
  if (!_isApple(context)) {
    return showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
    );
  }
  return _showWheel<DateTime>(
    context,
    initial: initial,
    builder: (onChanged) => CupertinoDatePicker(
      mode: CupertinoDatePickerMode.date,
      initialDateTime: initial,
      minimumDate: first,
      maximumDate: last,
      onDateTimeChanged: onChanged,
    ),
  );
}

/// Time picker that follows the platform: a wheel sheet on iOS, the Material
/// clock dialog elsewhere.
Future<TimeOfDay?> showAdaptiveTimePicker(
  BuildContext context, {
  required TimeOfDay initial,
}) async {
  if (!_isApple(context)) {
    return showTimePicker(context: context, initialTime: initial);
  }
  final now = DateTime.now();
  final start = DateTime(
    now.year,
    now.month,
    now.day,
    initial.hour,
    initial.minute,
  );
  final picked = await _showWheel<DateTime>(
    context,
    initial: start,
    builder: (onChanged) => CupertinoDatePicker(
      mode: CupertinoDatePickerMode.time,
      initialDateTime: start,
      use24hFormat: MediaQuery.alwaysUse24HourFormatOf(context),
      onDateTimeChanged: onChanged,
    ),
  );
  return picked == null ? null : TimeOfDay.fromDateTime(picked);
}

Future<T?> _showWheel<T>(
  BuildContext context, {
  required T initial,
  required Widget Function(ValueChanged<T> onChanged) builder,
}) {
  final v = context.veyro;
  var value = initial;
  return showCupertinoModalPopup<T>(
    context: context,
    builder: (sheet) => CupertinoTheme(
      data: CupertinoThemeData(
        brightness: Theme.of(context).brightness,
        textTheme: CupertinoTextThemeData(
          dateTimePickerTextStyle: VeyroText.body(21, color: v.ink),
        ),
      ),
      child: Container(
        height: 300,
        padding: const EdgeInsets.only(top: 6),
        color: v.card,
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    onPressed: () => Navigator.pop(sheet),
                    child: Text(
                      'Cancel',
                      style: VeyroText.body(16, color: v.mute),
                    ),
                  ),
                  CupertinoButton(
                    onPressed: () => Navigator.pop(sheet, value),
                    child: Text(
                      'Done',
                      style: VeyroText.body(
                        16,
                        weight: FontWeight.w700,
                        color: v.acc,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(child: builder((next) => value = next)),
            ],
          ),
        ),
      ),
    ),
  );
}
