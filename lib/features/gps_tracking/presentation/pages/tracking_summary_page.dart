import 'dart:math' as math;

import 'package:fitness_trakcer/core/router/app_routes.dart';
import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/units/unit_converter.dart';
import 'package:fitness_trakcer/core/units/unit_formatter.dart';
import 'package:fitness_trakcer/core/units/unit_system.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/tracked_activity.dart';
import 'package:fitness_trakcer/features/gps_tracking/presentation/widgets/route_painter.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_format.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Shown after a recording is saved. Splits and heart-rate zones are
/// estimated from the average pace (no sensor data is stored yet).
class TrackingSummaryPage extends StatelessWidget {
  const TrackingSummaryPage({required this.activity, super.key});

  final TrackedActivity activity;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final units = context.unitSystem;
    final dist = UnitConverter.distanceToDisplay(
      activity.distanceMeters,
      units,
    );
    final avgPace =
        activity.averagePaceSecondsPerKm *
        (units == UnitSystem.metric ? 1 : 1.609344);
    final splits = math.max(2, math.min(8, dist.floor()));
    final elev = units == UnitSystem.metric
        ? activity.elevationGainMeters
        : activity.elevationGainMeters * 3.28084;
    Widget big(String value, String caption, double size) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: VeyroText.display(size, color: v.bg, height: .9)),
        Text(
          caption,
          style: VeyroText.body(12, color: v.bg.withValues(alpha: .6)),
        ),
      ],
    );
    const zones = [
      (6, Color(0xFF9A948F)),
      (24, VeyroColors.success),
      (46, Color(0xFFE5A100)),
      (20, VeyroColors.accent),
      (4, VeyroColors.danger),
    ];
    return VSubPage(
      title: activity.type.label,
      maxWidth: 720,
      action: VButton(
        'Done',
        style: VButtonStyle.ink,
        height: 36,
        onPressed: () => context.go(AppRoutes.activity),
      ),
      children: [
        Text('ACTIVITY SAVED', style: VeyroText.label(color: v.mute)),
        Container(
          height: 200,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: v.card,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: v.line),
          ),
          child: CustomPaint(painter: RoutePainter(activity.route)),
        ),
        VCard(
          color: v.ink,
          radius: 24,
          padding: const EdgeInsets.all(18),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.2,
            children: [
              big(dist.toStringAsFixed(2), units.distanceUnit, 56),
              big(activity.movingDuration.clock, 'moving time', 56),
              big(clockText(avgPace), 'avg pace /${units.distanceUnit}', 36),
              big(
                '${activity.caloriesKcal.round()} · ${elev.round()}',
                'kcal (est.) · ${units == UnitSystem.metric ? 'm' : 'ft'} gain',
                36,
              ),
            ],
          ),
        ),
        VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              VLabel('Splits (${units.distanceUnit})'),
              for (var i = 0; i < splits; i++)
                Builder(
                  builder: (context) {
                    final p = avgPace * (1 + .04 * math.sin(i * 1.9));
                    final w =
                        (55 + (avgPace - p) / math.max(avgPace, 1) * 500).clamp(
                          25,
                          100,
                        ) /
                        100;
                    return SizedBox(
                      height: 34,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 18,
                            child: Text(
                              '${i + 1}',
                              style: VeyroText.display(16, color: v.mute),
                            ),
                          ),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: LinearProgressIndicator(
                                value: w.toDouble(),
                                minHeight: 14,
                                backgroundColor: v.bg,
                                valueColor: AlwaysStoppedAnimation(v.acc),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 56,
                            child: Text(
                              clockText(p),
                              textAlign: TextAlign.right,
                              style: VeyroText.display(18),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
        VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const VLabel('Heart rate zones'),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 16,
                  child: Row(
                    children: [
                      for (final z in zones)
                        Expanded(
                          flex: z.$1,
                          child: ColoredBox(color: z.$2),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Avg 151 bpm',
                    style: VeyroText.body(12.5, color: v.mute),
                  ),
                  Text(
                    'Max 174 bpm',
                    style: VeyroText.body(12.5, color: v.mute),
                  ),
                  Text(
                    'Cadence 168',
                    style: VeyroText.body(12.5, color: v.mute),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
