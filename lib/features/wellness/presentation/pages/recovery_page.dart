import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/widgets/veyro_charts.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:fitness_trakcer/features/recovery/domain/entities/recovery_snapshot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _amber = Color(0xFFE5A100);

/// Readiness, HRV, resting HR, muscle recovery and zones (sample data).
class RecoveryPage extends StatelessWidget {
  const RecoveryPage({super.key});

  static const _muscles = [
    ('Chest', 92),
    ('Back', 58),
    ('Shoulders', 84),
    ('Quads', 41),
    ('Hamstrings', 55),
    ('Glutes', 63),
    ('Biceps', 70),
    ('Triceps', 88),
    ('Core', 100),
  ];

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final summary = context.watch<DashboardCubit>().state.summary;
    final readiness = summary?.readiness;
    final recovery = summary?.recovery;
    final hrv = [
      for (final d in recovery?.days ?? const <RecoveryDay>[])
        if (d.hrvMs != null) d.hrvMs!,
    ];
    final rhr = [
      for (final d in recovery?.days ?? const <RecoveryDay>[])
        if (d.restingHr != null) d.restingHr!,
    ];
    Widget card(String label, String value, List<double> values, Color color) =>
        VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  VLabel(label),
                  Text(value, style: VeyroText.display(24)),
                ],
              ),
              const SizedBox(height: 8),
              if (values.length < 2)
                Text(
                  'Not enough readings yet.',
                  style: VeyroText.body(13, color: v.mute),
                )
              else
                VLinePlot(values: values, color: color),
            ],
          ),
        );
    final zones = [
      ('Z1', 'Warm-up', 34, v.mute),
      ('Z2', 'Easy', 92, VeyroColors.success),
      ('Z3', 'Tempo', 48, _amber),
      ('Z4', 'Threshold', 21, v.acc),
      ('Z5', 'Max', 6, VeyroColors.danger),
    ];
    return VSubPage(
      title: 'Recovery\n& heart',
      maxWidth: 720,
      children: [
        if (readiness == null)
          const VEmpty(
            'No readiness yet. It needs sleep, HRV or resting heart rate from Health.',
          )
        else
          VCard(
            child: Row(
              children: [
                VRing(
                  fraction: readiness.score / 100,
                  color: readiness.score >= 60
                      ? VeyroColors.success
                      : readiness.score >= 40
                      ? _amber
                      : VeyroColors.danger,
                  size: 104,
                  child: Text(
                    '${readiness.score}',
                    style: VeyroText.display(28),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const VLabel('Readiness'),
                      Text(
                        readiness.label.toUpperCase(),
                        style: VeyroText.display(30),
                      ),
                      Text(
                        readiness.summary,
                        style: VeyroText.body(12.5, color: v.mute),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        card(
          'HRV · 14 days',
          hrv.isEmpty ? '—' : '${hrv.last.round()} ms',
          hrv,
          VeyroColors.success,
        ),
        card(
          'Resting heart rate',
          rhr.isEmpty ? '—' : '${rhr.last.round()} bpm',
          rhr,
          v.acc,
        ),
        VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const VLabel('Muscle recovery · sample'),
              for (final m in _muscles)
                SizedBox(
                  height: 34,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 86,
                        child: Text(
                          m.$1,
                          style: VeyroText.body(13.5, weight: FontWeight.w600),
                        ),
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: m.$2 / 100,
                            minHeight: 8,
                            backgroundColor: v.bg,
                            valueColor: AlwaysStoppedAnimation(
                              m.$2 >= 80
                                  ? VeyroColors.success
                                  : m.$2 >= 55
                                  ? _amber
                                  : VeyroColors.danger,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 78,
                        child: Text(
                          m.$2 >= 80
                              ? 'Ready'
                              : m.$2 >= 55
                              ? 'Recovering'
                              : 'Fatigued',
                          textAlign: TextAlign.right,
                          style: VeyroText.body(12, color: v.mute),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const VLabel('Heart rate zones · sample'),
              for (final z in zones)
                SizedBox(
                  height: 34,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 78,
                        child: Text.rich(
                          TextSpan(
                            text: '${z.$1} ',
                            children: [
                              TextSpan(
                                text: z.$2,
                                style: VeyroText.body(11.5, color: v.mute),
                              ),
                            ],
                          ),
                          style: VeyroText.body(13, weight: FontWeight.w600),
                        ),
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: z.$3 / 92,
                            minHeight: 8,
                            backgroundColor: v.bg,
                            valueColor: AlwaysStoppedAnimation(z.$4),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 34,
                        child: Text(
                          '${z.$3}',
                          textAlign: TextAlign.right,
                          style: VeyroText.display(17),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
