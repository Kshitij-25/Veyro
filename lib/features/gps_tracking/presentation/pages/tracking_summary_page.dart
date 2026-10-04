import 'dart:math' as math;

import 'package:fitness_trakcer/core/di/injection.dart';
import 'package:fitness_trakcer/core/router/app_routes.dart';
import 'package:fitness_trakcer/core/share/share_summary.dart';
import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/units/unit_converter.dart';
import 'package:fitness_trakcer/core/units/unit_formatter.dart';
import 'package:fitness_trakcer/core/units/unit_system.dart';
import 'package:fitness_trakcer/core/utils/date_range.dart';
import 'package:fitness_trakcer/core/utils/geo.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/activity/data/datasources/health_data_source.dart';
import 'package:fitness_trakcer/features/activity/data/models/health_heart_rate_sample.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/tracked_activity.dart';
import 'package:fitness_trakcer/features/gps_tracking/presentation/widgets/route_painter.dart';
import 'package:fitness_trakcer/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:fitness_trakcer/features/recovery/domain/entities/heart_rate_zones.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Shown after a recording is saved. Splits come from the recorded route;
/// heart rate comes from Health when a watch recorded it during the activity.
class TrackingSummaryPage extends StatefulWidget {
  const TrackingSummaryPage({required this.activity, super.key});

  final TrackedActivity activity;

  @override
  State<TrackingSummaryPage> createState() => _TrackingSummaryPageState();
}

class _Split {
  const _Split(this.seconds, this.fraction);

  /// Seconds per full unit (extrapolated for a partial last split).
  final double seconds;

  /// Length of the split as a share of a full unit.
  final double fraction;
}

class _TrackingSummaryPageState extends State<TrackingSummaryPage> {
  List<HealthHeartRateSample> _hr = const [];

  TrackedActivity get activity => widget.activity;

  @override
  void initState() {
    super.initState();
    _loadHeartRate();
  }

  Future<void> _loadHeartRate() async {
    try {
      final samples = await getIt<HealthDataSource>().getHeartRateSamples(
        DateRange(activity.startedAt, activity.endedAt),
      );
      if (mounted) setState(() => _hr = samples);
    } on Object {
      // No Health access: the card simply stays hidden.
    }
  }

  /// Time for each full distance unit along the route. A trailing piece
  /// under a tenth of a unit is dropped.
  List<_Split> _splits(UnitSystem units) {
    final route = activity.route;
    if (route.length < 2) return const [];
    final unit = units == UnitSystem.metric ? 1000.0 : 1609.344;
    final out = <_Split>[];
    var splitStart = route.first.timestamp;
    var splitMeters = 0.0;
    for (var i = 1; i < route.length; i++) {
      final a = route[i - 1];
      final b = route[i];
      final total = Geo.distanceMeters(
        a.latitude,
        a.longitude,
        b.latitude,
        b.longitude,
      );
      final segTime = b.timestamp.difference(a.timestamp);
      var segment = total;
      var segStart = a.timestamp;
      while (segment > 0 && splitMeters + segment >= unit) {
        final need = unit - splitMeters;
        final at = segStart.add(
          Duration(
            microseconds: (segTime.inMicroseconds * (need / total)).round(),
          ),
        );
        out.add(_Split(at.difference(splitStart).inMilliseconds / 1000, 1));
        splitStart = at;
        segStart = at;
        segment -= need;
        splitMeters = 0;
      }
      splitMeters += segment;
    }
    if (splitMeters >= unit * .1 && out.isNotEmpty) {
      final secs =
          route.last.timestamp.difference(splitStart).inMilliseconds / 1000;
      out.add(_Split(secs / (splitMeters / unit), splitMeters / unit));
    }
    return out;
  }

  String _shareText(
    UnitSystem units,
    double dist,
    double avgPace,
    List<_Split> splits,
  ) {
    final b = StringBuffer(activity.displayName)
      ..writeln()
      ..writeln(DateFormat('EEEE, MMM d').format(activity.startedAt));
    if (activity.distanceMeters > 0) {
      b
        ..writeln('Distance: ${dist.toStringAsFixed(2)} ${units.distanceUnit}')
        ..writeln('Time: ${activity.movingDuration.clock}')
        ..writeln('Avg pace: ${clockText(avgPace)} /${units.distanceUnit}');
    } else {
      b.writeln('Time: ${activity.movingDuration.clock}');
    }
    if (activity.caloriesKcal > 0) {
      b.writeln('Calories: ${activity.caloriesKcal.round()} kcal (est.)');
    }
    if (splits.isNotEmpty) {
      b.writeln();
      for (final (i, s) in splits.indexed) {
        if (s.fraction >= 1) {
          b.writeln('${i + 1}. ${clockText(s.seconds)}');
        }
      }
    }
    b
      ..writeln()
      ..write('Tracked with Veyro');
    return b.toString();
  }

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
    final splits = _splits(units);
    final fastest = splits.isEmpty
        ? 0.0
        : splits.map((s) => s.seconds).reduce(math.min);
    final slowest = splits.isEmpty
        ? 0.0
        : splits.map((s) => s.seconds).reduce(math.max);
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
    final age = context.read<ProfileCubit>().state.profile?.ageOn(
      DateTime.now(),
    );
    final hrValues = [for (final h in _hr) h.bpm];
    final zones = age == null || hrValues.isEmpty
        ? null
        : HeartRateZoneCalculator.compute([
            for (final h in _hr) HeartRateSampleInput(h.time, h.bpm),
          ], 220 - age);
    const zoneColors = [
      Color(0xFF9A948F),
      VeyroColors.success,
      Color(0xFFE5A100),
      VeyroColors.accent,
      VeyroColors.danger,
    ];
    return VSubPage(
      title: activity.displayName,
      maxWidth: 720,
      action: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Builder(
            builder: (context) => IconButton.filled(
              style: IconButton.styleFrom(
                backgroundColor: v.card,
                foregroundColor: v.ink,
              ),
              tooltip: 'Share',
              onPressed: () => shareSummary(
                context,
                _shareText(units, dist, avgPace, splits),
              ),
              icon: Icon(Icons.adaptive.share, size: 20),
            ),
          ),
          const SizedBox(width: 8),
          VButton(
            'Done',
            style: VButtonStyle.ink,
            height: 36,
            onPressed: () => context.push(AppRoutes.activity),
          ),
        ],
      ),
      children: [
        Text('ACTIVITY SAVED', style: VeyroText.label(color: v.mute)),
        if (activity.route.length >= 2)
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
        if (splits.isNotEmpty)
          VCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                VLabel('Splits (${units.distanceUnit})'),
                for (final (i, sp) in splits.indexed)
                  SizedBox(
                    height: 34,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 26,
                          child: Text(
                            sp.fraction < 1
                                ? sp.fraction.toStringAsFixed(1)
                                : '${i + 1}',
                            style: VeyroText.display(16, color: v.mute),
                          ),
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: LinearProgressIndicator(
                              value: slowest <= fastest
                                  ? 1
                                  : 1 -
                                        (sp.seconds - fastest) /
                                            (slowest - fastest) *
                                            .6,
                              minHeight: 14,
                              backgroundColor: v.bg,
                              valueColor: AlwaysStoppedAnimation(v.acc),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 56,
                          child: Text(
                            clockText(sp.seconds),
                            textAlign: TextAlign.right,
                            style: VeyroText.display(18),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        if (hrValues.isNotEmpty)
          VCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const VLabel('Heart rate'),
                const SizedBox(height: 8),
                if (zones != null && zones.totalMinutes > 0)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 16,
                      child: Row(
                        children: [
                          for (final (i, m) in zones.minutes.indexed)
                            if (m > 0)
                              Expanded(
                                flex: m,
                                child: ColoredBox(color: zoneColors[i]),
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
                      'Avg ${(hrValues.reduce((a, b) => a + b) / hrValues.length).round()} bpm',
                      style: VeyroText.body(12.5, color: v.mute),
                    ),
                    Text(
                      'Max ${hrValues.reduce(math.max).round()} bpm',
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
