import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const _blue = Color(0xFF2F6FE5);

/// Training calendar with sample activity marks.
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  static const _prev = {
    1: 'S',
    3: 'S',
    5: 'R',
    8: 'S',
    10: 'S',
    12: 'C',
    15: 'S',
    17: 'S',
    19: 'R',
    22: 'S',
    24: 'S',
    26: 'S',
    27: 'W',
    29: 'S',
  };
  static const _cur = {1: 'S', 2: 'W'};
  static const _planned = {1: 'Push Day', 3: 'Legs', 5: 'Pull Day'};

  final DateTime _today = DateTime.now();
  bool _previous = false;
  late int _selected = _today.day;

  DateTime get _month => _previous
      ? DateTime(_today.year, _today.month - 1)
      : DateTime(_today.year, _today.month);

  Map<int, String> get _marks => _previous ? _prev : _cur;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final units = context.unitSystem;
    final month = _month;
    final lead = DateTime(month.year, month.month, 1).weekday % 7;
    final days = DateTime(month.year, month.month + 1, 0).day;
    final marks = _marks;
    Color fill(String m) => switch (m) {
      'S' => v.acc,
      'R' => v.ink,
      'C' => _blue,
      _ => VeyroColors.success,
    };
    Color on(String m) => switch (m) {
      'S' => VeyroColors.onAccent,
      'R' => v.bg,
      _ => Colors.white,
    };
    final sel = DateTime(month.year, month.month, _selected.clamp(1, days));
    final isFuture = !_previous && sel.isAfter(_today);
    final planned = isFuture ? _planned[sel.weekday % 7] : null;
    final mark = marks[sel.day];
    final title = switch (mark) {
      'S' => 'Strength workout',
      'R' => 'Run · ${units.fd(8.05)} ${units.distanceUnit}',
      'C' => 'Cycle · ${units.fd(24.1)} ${units.distanceUnit}',
      'W' => 'Walk · ${units.fd(3.2)} ${units.distanceUnit}',
      _ => planned != null ? 'Planned: $planned' : 'Rest day',
    };
    final sub = mark != null
        ? 'Completed'
        : planned != null
        ? 'From your routines'
        : 'Nothing logged';
    return VSubPage(
      title: 'Calendar',
      maxWidth: 720,
      children: [
        VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _Nav(
                    icon: Icons.chevron_left,
                    onTap: () => setState(() {
                      _previous = true;
                      _selected = 1;
                    }),
                  ),
                  Column(
                    children: [
                      Text(
                        DateFormat('MMMM yyyy').format(month).toUpperCase(),
                        style: VeyroText.display(26),
                      ),
                      Text(
                        '${marks.length} active days',
                        style: VeyroText.body(12, color: v.mute),
                      ),
                    ],
                  ),
                  _Nav(
                    icon: Icons.chevron_right,
                    onTap: () => setState(() {
                      _previous = false;
                      _selected = _today.day;
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  for (final d in const ['S', 'M', 'T', 'W', 'T', 'F', 'S'])
                    Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: VeyroText.body(
                            11,
                            weight: FontWeight.w600,
                            color: v.mute,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              GridView.count(
                crossAxisCount: 7,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: [
                  for (var i = 0; i < lead; i++) const SizedBox.shrink(),
                  for (var d = 1; d <= days; d++)
                    Builder(
                      builder: (context) {
                        final m = marks[d];
                        final date = DateTime(month.year, month.month, d);
                        final isToday = !_previous && d == _today.day;
                        final plan =
                            !_previous &&
                            date.isAfter(_today) &&
                            _planned.containsKey(date.weekday % 7);
                        return GestureDetector(
                          onTap: () => setState(() => _selected = d),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: m != null ? fill(m) : Colors.transparent,
                              border: Border.all(
                                color: d == _selected
                                    ? v.acc
                                    : isToday
                                    ? v.ink
                                    : plan
                                    ? v.mute
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              '$d',
                              style: VeyroText.body(
                                13,
                                weight: FontWeight.w700,
                                color: m != null ? on(m) : v.ink,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12,
                runSpacing: 4,
                children: [
                  for (final l in [
                    ('● Strength', v.acc),
                    ('● Run', v.ink),
                    ('● Cycle', _blue),
                    ('● Walk', VeyroColors.success),
                    ('○ Planned', v.mute),
                  ])
                    Text(l.$1, style: VeyroText.body(11.5, color: l.$2)),
                ],
              ),
            ],
          ),
        ),
        VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VLabel(DateFormat('MMM d').format(sel)),
              Text(
                title.toUpperCase(),
                style: VeyroText.display(26, height: 1.1),
              ),
              Text(sub, style: VeyroText.body(13, color: v.mute)),
            ],
          ),
        ),
      ],
    );
  }
}

class _Nav extends StatelessWidget {
  const _Nav({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 36,
    height: 36,
    child: IconButton.filled(
      padding: EdgeInsets.zero,
      style: IconButton.styleFrom(
        backgroundColor: context.veyro.bg,
        foregroundColor: context.veyro.ink,
      ),
      onPressed: onTap,
      icon: Icon(icon),
    ),
  );
}
