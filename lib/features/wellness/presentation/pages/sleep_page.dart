import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/widgets/veyro_charts.dart';
import 'package:fitness_trakcer/core/widgets/veyro_extras.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_store.dart';
import 'package:flutter/material.dart';

const _awake = Color(0xFFE5A100);
const _rem = Color(0xFFFF5A2B);
const _light = Color(0xFF7B8794);
const _deep = Color(0xFF2F6FE5);

/// Last night's sleep and a 7-night trend (sample data).
class SleepPage extends StatelessWidget {
  const SleepPage({super.key});

  static const _stages = <(String, int)>[
    ('L', 30),
    ('D', 50),
    ('L', 25),
    ('D', 40),
    ('R', 20),
    ('L', 35),
    ('D', 22),
    ('L', 28),
    ('R', 34),
    ('L', 26),
    ('A', 8),
    ('L', 24),
    ('R', 40),
    ('L', 20),
    ('A', 10),
    ('R', 28),
  ];
  static const _hours = [7.1, 6.4, 7.8, 8.2, 6.9, 7.4, 7.6];

  static Color _color(String k) => switch (k) {
    'A' => _awake,
    'R' => _rem,
    'L' => _light,
    _ => _deep,
  };

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return WellnessBuilder(
      builder: (context, store) {
        final total = _stages.fold(0, (a, b) => a + b.$2);
        final y = {'A': 4.0, 'R': 30.0, 'L': 56.0, 'D': 82.0};
        return VSubPage(
          title: 'Sleep',
          maxWidth: 720,
          children: [
            VCard(
              color: v.ink,
              radius: 26,
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  VRing(
                    fraction: .84,
                    color: v.acc,
                    size: 104,
                    child: Text(
                      '84',
                      style: VeyroText.display(28, color: v.bg),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('7h 36m', style: VeyroText.display(44, color: v.bg)),
                      Text(
                        '11:12 pm to 6:48 am',
                        style: VeyroText.body(
                          13,
                          color: v.bg.withValues(alpha: .7),
                        ),
                      ),
                      Text(
                        'Sleep score 84',
                        style: VeyroText.body(
                          12,
                          color: v.bg.withValues(alpha: .6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            VCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const VLabel('Last night'),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 100,
                    child: LayoutBuilder(
                      builder: (context, c) {
                        var x = 0.0;
                        final bars = <Widget>[];
                        for (final s in _stages) {
                          final left = x / total * c.maxWidth;
                          final w = (s.$2 / total * c.maxWidth - 2).clamp(
                            2.0,
                            c.maxWidth,
                          );
                          x += s.$2;
                          bars.add(
                            Positioned(
                              left: left,
                              width: w,
                              top: y[s.$1],
                              height: 14,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: _color(s.$1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          );
                        }
                        return Stack(children: bars);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      for (final s in const [
                        ('Awake', '24m', 'A'),
                        ('REM', '1h 49m', 'R'),
                        ('Light', '3h 42m', 'L'),
                        ('Deep', '1h 41m', 'D'),
                      ])
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: _color(s.$3),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    s.$1,
                                    style: VeyroText.body(11.5, color: v.mute),
                                  ),
                                ],
                              ),
                              Text(s.$2, style: VeyroText.display(20)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            VCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const VLabel('Last 7 nights (h)'),
                  const SizedBox(height: 8),
                  VBarChart(
                    values: _hours,
                    labels: const ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
                    captions: [for (final h in _hours) h.toStringAsFixed(1)],
                    colors: [
                      for (final h in _hours)
                        h >= store.sleepGoalHours ? v.acc : v.mute,
                    ],
                    maxValue: 9,
                    height: 160,
                  ),
                ],
              ),
            ),
            VGrid2(
              children: const [
                VStatTile(label: 'Efficiency', value: '92%'),
                VStatTile(label: 'Avg bedtime', value: '11:08 pm'),
                VStatTile(label: 'Sleep debt', value: '1h 12m'),
                VStatTile(label: 'Sleeping HR', value: '49 bpm'),
              ],
            ),
            VCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  VStepper(
                    label: 'Sleep goal (h)',
                    value: store.sleepGoalHours.toStringAsFixed(1),
                    onMinus: () =>
                        store.setSleepGoal(store.sleepGoalHours - .5),
                    onPlus: () => store.setSleepGoal(store.sleepGoalHours + .5),
                  ),
                  const SizedBox(height: 14),
                  VToggleRow(
                    title: 'Wind-down reminder',
                    subtitle: '45 minutes before bedtime',
                    value: store.windDown,
                    onChanged: store.setWindDown,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
