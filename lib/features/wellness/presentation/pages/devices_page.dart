import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_store.dart';
import 'package:flutter/material.dart';

/// Connected devices and integrations (sample toggles; none connect yet).
class DevicesPage extends StatelessWidget {
  const DevicesPage({super.key});

  static const _devices = [
    ('health', 'Apple Health', 'Steps, workouts, heart rate, sleep'),
    ('watch', 'Apple Watch', 'Live heart rate during workouts'),
    ('garmin', 'Garmin Connect', 'Import runs, rides and daily stats'),
    ('strava', 'Strava', 'Share activities automatically'),
    ('whoop', 'WHOOP', 'Recovery and strain'),
    ('oura', 'Oura Ring', 'Sleep and readiness'),
    ('fitbit', 'Fitbit', 'Steps and sleep'),
    ('spotify', 'Spotify', 'Music controls during workouts'),
  ];

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return WellnessBuilder(
      builder: (context, store) => VSubPage(
        title: 'Devices &\nintegrations',
        maxWidth: 720,
        children: [
          for (final d in _devices)
            VCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: v.bg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          d.$2,
                          style: VeyroText.body(16, weight: FontWeight.w700),
                        ),
                        Text(d.$3, style: VeyroText.body(12, color: v.mute)),
                      ],
                    ),
                  ),
                  VButton(
                    store.devices[d.$1]! ? 'Connected' : 'Connect',
                    style: store.devices[d.$1]!
                        ? VButtonStyle.soft
                        : VButtonStyle.ink,
                    height: 34,
                    onPressed: () => store.toggleDevice(d.$1),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
