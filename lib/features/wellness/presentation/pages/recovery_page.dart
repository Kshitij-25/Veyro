import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/widgets/veyro_charts.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:fitness_trakcer/features/recovery/domain/entities/recovery_details.dart';
import 'package:fitness_trakcer/features/recovery/domain/entities/recovery_snapshot.dart';
import 'package:fitness_trakcer/features/recovery/presentation/cubit/recovery_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _amber = Color(0xFFE5A100);

/// Readiness, HRV, resting HR, muscle recovery and heart-rate zones.
class RecoveryPage extends StatelessWidget {
  const RecoveryPage({super.key});

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
    final details = context.watch<RecoveryDetailsCubit>().state.details;
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
        if (details != null) ...[
          _MuscleCard(details: details),
          _ZonesCard(details: details),
        ],
      ],
    );
  }
}

Color _recoveryColor(int percent) => percent >= 80
    ? VeyroColors.success
    : percent >= 55
    ? _amber
    : VeyroColors.danger;

String _ago(DateTime t, DateTime now) {
  final hours = now.difference(t).inHours;
  if (hours < 1) return 'just now';
  if (hours < 24) return '${hours}h ago';
  return '${hours ~/ 24}d ago';
}

class _MuscleCard extends StatelessWidget {
  const _MuscleCard({required this.details});

  final RecoveryDetails details;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final now = DateTime.now();
    return VCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VLabel('Muscle recovery'),
          const SizedBox(height: 4),
          if (!details.hasTrained)
            Text(
              'No workouts logged in the last two weeks, so every muscle counts as rested.',
              style: VeyroText.body(13, color: v.mute, height: 1.4),
            ),
          for (final m in details.muscles)
            SizedBox(
              height: 44,
              child: Row(
                children: [
                  SizedBox(
                    width: 86,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          m.group.label,
                          style: VeyroText.body(13.5, weight: FontWeight.w600),
                        ),
                        if (m.lastTrained != null)
                          Text(
                            _ago(m.lastTrained!, now),
                            style: VeyroText.body(11, color: v.mute),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: m.percent / 100,
                        minHeight: 8,
                        backgroundColor: v.bg,
                        valueColor: AlwaysStoppedAnimation(
                          _recoveryColor(m.percent),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 82,
                    child: Text(
                      m.status,
                      textAlign: TextAlign.right,
                      style: VeyroText.body(12, color: v.mute),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 4),
          Text(
            'Estimated from your logged sets and how long ago you trained. More working sets in the last three days means a longer recovery window.',
            style: VeyroText.body(11.5, color: v.mute, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _ZonesCard extends StatelessWidget {
  const _ZonesCard({required this.details});

  final RecoveryDetails details;

  static const _names = ['Warm-up', 'Easy', 'Tempo', 'Threshold', 'Max'];

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final zones = details.zones;
    final colors = [
      v.mute,
      VeyroColors.success,
      _amber,
      v.acc,
      VeyroColors.danger,
    ];
    return VCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VLabel('Heart rate zones · last 7 days'),
          const SizedBox(height: 4),
          if (zones == null)
            Text(
              'No heart-rate data yet. Connect Health and wear your watch to see time in each zone.',
              style: VeyroText.body(13, color: v.mute, height: 1.4),
            )
          else ...[
            for (var i = 0; i < 5; i++)
              SizedBox(
                height: 34,
                child: Row(
                  children: [
                    SizedBox(
                      width: 96,
                      child: Text.rich(
                        TextSpan(
                          text: 'Z${i + 1} ',
                          children: [
                            TextSpan(
                              text: _names[i],
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
                          value:
                              zones.minutes.reduce((a, b) => a > b ? a : b) == 0
                              ? 0
                              : zones.minutes[i] /
                                    zones.minutes.reduce(
                                      (a, b) => a > b ? a : b,
                                    ),
                          minHeight: 8,
                          backgroundColor: v.bg,
                          valueColor: AlwaysStoppedAnimation(colors[i]),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 64,
                      child: Text(
                        '${zones.minutes[i]} min',
                        textAlign: TextAlign.right,
                        style: VeyroText.body(12.5, weight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 4),
            Text(
              'Zones use an estimated max of ${zones.maxHr} bpm (220 minus your age). Only time above 50% of max counts; below that is rest.',
              style: VeyroText.body(11.5, color: v.mute, height: 1.4),
            ),
          ],
        ],
      ),
    );
  }
}
