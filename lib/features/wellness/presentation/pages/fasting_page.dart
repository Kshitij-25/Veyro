import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/units/unit_formatter.dart';
import 'package:fitness_trakcer/core/widgets/veyro_charts.dart';
import 'package:fitness_trakcer/core/widgets/veyro_extras.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_format.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_store.dart';
import 'package:flutter/material.dart';

class FastingPage extends StatelessWidget {
  const FastingPage({super.key});

  static const _stages = [
    ('Fed state', '0–4 h', 0),
    ('Early fasting', '4–8 h', 4),
    ('Fat burning', '8–12 h', 8),
    ('Deep fasting', '12–16 h', 12),
    ('Autophagy', '16 h+', 16),
  ];

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return WellnessBuilder(
      builder: (context, store) => StreamBuilder<int>(
        stream: Stream.periodic(const Duration(seconds: 1), (i) => i),
        builder: (context, _) {
          final elapsed = store.fastOn
              ? DateTime.now().difference(store.fastStart).inSeconds
              : 0;
          final goal = store.fastHours * 3600;
          final hours = elapsed / 3600;
          return VSubPage(
            title: 'Fasting',
            maxWidth: 560,
            children: [
              VCard(
                child: Center(
                  child: VRing(
                    fraction: store.fastOn ? elapsed / goal : 0,
                    color: v.acc,
                    size: 210,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(clockText(elapsed), style: VeyroText.display(54)),
                        Text(
                          !store.fastOn
                              ? 'Not fasting'
                              : elapsed >= goal
                              ? 'Goal reached'
                              : '${Duration(seconds: goal - elapsed).clock} to go',
                          style: VeyroText.body(13, color: v.mute),
                        ),
                        Text(
                          '${store.fastHours}:${24 - store.fastHours}',
                          style: VeyroText.body(13, color: v.mute),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              VButton(
                store.fastOn ? 'End fast' : 'Start fast',
                height: 52,
                radius: 16,
                expand: true,
                onPressed: store.toggleFast,
              ),
              VChipRow<int>(
                options: {
                  for (final h in [12, 14, 16, 18, 20]) h: '$h:${24 - h}',
                },
                selected: store.fastHours,
                onChanged: store.setFastHours,
              ),
              VCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const VLabel('Stages'),
                    const SizedBox(height: 6),
                    for (final s in _stages)
                      Builder(
                        builder: (context) {
                          final on = store.fastOn && hours >= s.$3;
                          return Container(
                            height: 44,
                            margin: const EdgeInsets.only(top: 6),
                            decoration: BoxDecoration(
                              border: Border(top: BorderSide(color: v.line)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 26,
                                  height: 26,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: on ? v.acc : v.bg,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    on ? '✓' : '',
                                    style: VeyroText.body(
                                      13,
                                      weight: FontWeight.w800,
                                      color: VeyroColors.onAccent,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    s.$1,
                                    style: VeyroText.body(
                                      15,
                                      weight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Text(
                                  s.$2,
                                  style: VeyroText.body(12.5, color: v.mute),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
