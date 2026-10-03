import 'dart:math' as math;

import 'package:fitness_trakcer/core/layout/content_constraint.dart';
import 'package:fitness_trakcer/core/router/app_routes.dart';
import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/units/unit_converter.dart';
import 'package:fitness_trakcer/core/units/unit_formatter.dart';
import 'package:fitness_trakcer/core/units/unit_system.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/location_permission_status.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/tracked_activity_type.dart';
import 'package:fitness_trakcer/features/gps_tracking/domain/entities/tracking_status.dart';
import 'package:fitness_trakcer/features/gps_tracking/presentation/cubit/tracking_cubit.dart';
import 'package:fitness_trakcer/features/gps_tracking/presentation/widgets/route_painter.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

const _bg = Color(0xFF101010);
const _fg = Color(0xFFF5F3F0);
const _panel = Color(0xFF242220);
const _muted = Color(0xFF9A948F);

/// Live GPS recording screen. Always dark, like a workout watch face.
/// `state.snapshot.route` holds the points drawn on the placeholder map.
class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final units = context.unitSystem;
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: BlocConsumer<TrackingCubit, TrackingState>(
          listenWhen: (previous, current) =>
              (current.failure != null &&
                  current.failure != previous.failure) ||
              (current.savedActivity != null && previous.savedActivity == null),
          listener: (context, state) {
            final saved = state.savedActivity;
            if (saved != null) {
              context.read<TrackingCubit>().acknowledgeSaved();
              context.go(AppRoutes.trackingSummary, extra: saved);
              return;
            }
            final message = state.failure?.message;
            if (message != null) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(message)));
            }
          },
          builder: (context, state) {
            final cubit = context.read<TrackingCubit>();
            final snapshot = state.snapshot;
            final idle = state.status == TrackingStatus.idle;
            final distance = UnitConverter.distanceToDisplay(
              snapshot?.distanceMeters ?? 0,
              units,
            );
            final pace = units
                .formatPace(snapshot?.currentPaceSecondsPerKm ?? 0)
                .split(' ')
                .first;
            final elevation = units == UnitSystem.metric
                ? (snapshot?.elevationGainMeters ?? 0)
                : (snapshot?.elevationGainMeters ?? 0) * 3.28084;
            final denied =
                state.permission != null && !state.permission!.isGranted;
            final header = Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: _panel,
                      foregroundColor: _fg,
                    ),
                    onPressed: () => veyroBack(context),
                    icon: const Icon(Icons.keyboard_arrow_down),
                  ),
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: _panel,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        for (final type in TrackedActivityType.values)
                          GestureDetector(
                            onTap: idle ? () => cubit.selectType(type) : null,
                            child: Container(
                              height: 32,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: type == state.type
                                    ? _fg
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Text(
                                type.label,
                                style: VeyroText.body(
                                  13,
                                  weight: FontWeight.w600,
                                  color: type == state.type ? _bg : _fg,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            );
            final readout = Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  switch (state.status) {
                    TrackingStatus.idle => 'READY',
                    TrackingStatus.tracking => 'RECORDING',
                    TrackingStatus.paused => 'PAUSED',
                  },
                  style: VeyroText.body(
                    11,
                    weight: FontWeight.w600,
                    color: _muted,
                    letterSpacing: 1.4,
                  ),
                ),
                Text(
                  (snapshot?.elapsed ?? Duration.zero).clock,
                  style: VeyroText.display(116, color: _fg, height: .9),
                ),
              ],
            );
            final secs = snapshot?.elapsed.inSeconds ?? 0;
            final live = state.status == TrackingStatus.tracking;
            final hr = live
                ? (138 + 10 * math.sin(secs / 4) + secs / 60).round().toString()
                : '--';
            final cadence = live
                ? (state.type == TrackedActivityType.cycle
                      ? '84 rpm'
                      : '168 spm')
                : '--';
            final stats = Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
                  child: Row(
                    children: [
                      _Stat(distance.toStringAsFixed(2), units.distanceUnit),
                      _Stat(pace, '/${units.distanceUnit}'),
                      _Stat(
                        elevation.round().toString(),
                        '${units == UnitSystem.metric ? 'm' : 'ft'} gain',
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
                  child: Row(
                    children: [
                      _Tile('Heart rate', hr, 'bpm'),
                      const SizedBox(width: 10),
                      _Tile('Cadence', cadence, ''),
                    ],
                  ),
                ),
              ],
            );
            final map = Container(
              margin: const EdgeInsets.symmetric(horizontal: 14),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1918),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CustomPaint(
                    painter: RoutePainter(snapshot?.route ?? const []),
                  ),
                  Positioned(
                    left: 14,
                    top: 12,
                    child: Text(
                      'map placeholder · GPS route',
                      style: GoogleFonts.robotoMono(
                        fontSize: 11,
                        color: const Color(0xFF7D7772),
                      ),
                    ),
                  ),
                  if (denied)
                    Container(
                      color: _bg.withValues(alpha: .88),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'LOCATION IS OFF',
                            style: VeyroText.display(28, color: _fg),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            state.permission ==
                                    LocationPermissionStatus.serviceDisabled
                                ? 'Turn on location services to record routes.'
                                : 'Allow location access in Settings to record routes.',
                            textAlign: TextAlign.center,
                            style: VeyroText.body(
                              13,
                              color: const Color(0xFFC9C3BD),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
            final controls = Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: switch (state.status) {
                TrackingStatus.idle => Row(
                  children: [
                    Expanded(
                      child: _BigButton(
                        'Start',
                        bg: VeyroColors.accent,
                        fg: VeyroColors.onAccent,
                        onPressed: state.isSaving ? null : cubit.start,
                      ),
                    ),
                  ],
                ),
                _ => Row(
                  children: [
                    TextButton(
                      onPressed: cubit.discard,
                      style: TextButton.styleFrom(
                        backgroundColor: _panel,
                        foregroundColor: _fg,
                        minimumSize: const Size(0, 64),
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Discard',
                        style: VeyroText.body(14, weight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _BigButton(
                        state.status == TrackingStatus.paused
                            ? 'Resume'
                            : 'Pause',
                        bg: _fg,
                        fg: _bg,
                        onPressed: state.status == TrackingStatus.paused
                            ? cubit.resume
                            : cubit.pause,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _BigButton(
                        'Finish',
                        bg: VeyroColors.accent,
                        fg: VeyroColors.onAccent,
                        onPressed: cubit.finish,
                      ),
                    ),
                  ],
                ),
              },
            );
            return LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 800) {
                  return ContentConstraint(
                    maxWidth: 1100,
                    child: Column(
                      children: [
                        header,
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: [
                                    readout,
                                    const SizedBox(height: 12),
                                    stats,
                                    const Spacer(),
                                    controls,
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    0,
                                    8,
                                    14,
                                    14,
                                  ),
                                  child: map,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ContentConstraint(
                  maxWidth: 560,
                  child: Column(
                    children: [
                      header,
                      readout,
                      stats,
                      Expanded(child: map),
                      controls,
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _BigButton extends StatelessWidget {
  const _BigButton(
    this.label, {
    required this.bg,
    required this.fg,
    required this.onPressed,
  });

  final String label;
  final Color bg;
  final Color fg;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 64,
    child: FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(
        label.toUpperCase(),
        style: VeyroText.display(26, color: fg).copyWith(letterSpacing: 2),
      ),
    ),
  );
}

class _Stat extends StatelessWidget {
  const _Stat(this.value, this.caption);

  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      children: [
        Text(value, style: VeyroText.display(46, color: _fg)),
        Text(
          caption.toUpperCase(),
          style: VeyroText.body(11, color: _muted, letterSpacing: .9),
        ),
      ],
    ),
  );
}

class _Tile extends StatelessWidget {
  const _Tile(this.label, this.value, this.unit);

  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _panel,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: VeyroText.body(11, color: _muted, letterSpacing: .9),
          ),
          Text.rich(
            TextSpan(
              text: value,
              children: [
                if (unit.isNotEmpty)
                  TextSpan(
                    text: ' $unit',
                    style: VeyroText.body(13, color: _muted),
                  ),
              ],
            ),
            style: VeyroText.display(30, color: _fg),
          ),
        ],
      ),
    ),
  );
}
