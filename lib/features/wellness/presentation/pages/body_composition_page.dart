import 'dart:math' as math;

import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/units/unit_converter.dart';
import 'package:fitness_trakcer/core/utils/parsing.dart';
import 'package:fitness_trakcer/core/widgets/loading_view.dart';
import 'package:fitness_trakcer/core/widgets/veyro_charts.dart';
import 'package:fitness_trakcer/core/widgets/veyro_extras.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/entities/body_measurement.dart';
import 'package:fitness_trakcer/features/body_metrics/domain/usecases/log_body_measurement.dart';
import 'package:fitness_trakcer/features/body_metrics/presentation/cubit/body_metrics_cubit.dart';
import 'package:fitness_trakcer/features/profile/domain/entities/sex.dart';
import 'package:fitness_trakcer/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

enum _Metric {
  weight('Weight'),
  bodyFat('Body fat'),
  leanMass('Lean mass'),
  waist('Waist');

  const _Metric(this.label);

  final String label;
}

/// Trends from your logged measurements, plus BMR/TDEE/BMI from your profile.
/// Lean mass is derived from entries that have both weight and body fat.
class BodyCompositionPage extends StatefulWidget {
  const BodyCompositionPage({super.key});

  @override
  State<BodyCompositionPage> createState() => _BodyCompositionPageState();
}

class _BodyCompositionPageState extends State<BodyCompositionPage> {
  _Metric _metric = _Metric.weight;
  int _range = 90;

  /// The value of [m] in a measurement, in display units (null if absent).
  double? _value(_Metric m, BodyMeasurement e, units) => switch (m) {
    _Metric.weight =>
      e.weightKg == null
          ? null
          : UnitConverter.weightToDisplay(e.weightKg!, units),
    _Metric.bodyFat => e.bodyFatPercent,
    _Metric.leanMass =>
      (e.weightKg == null || e.bodyFatPercent == null)
          ? null
          : UnitConverter.weightToDisplay(
              e.weightKg! * (1 - e.bodyFatPercent! / 100),
              units,
            ),
    _Metric.waist =>
      e.waistCm == null
          ? null
          : UnitConverter.lengthToDisplay(e.waistCm!, units),
  };

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final units = context.unitSystem;
    final profile = context.watch<ProfileCubit>().state.profile;
    final state = context.watch<BodyMetricsCubit>().state;
    if (state.status.isPending) return const Scaffold(body: LoadingView());

    final cutoff = DateTime.now().subtract(Duration(days: _range));
    final points = <(DateTime, double)>[
      for (final e in state.measurements.reversed)
        if (e.measuredAt.isAfter(cutoff) && _value(_metric, e, units) != null)
          (e.measuredAt, _value(_metric, e, units)!),
    ];
    final unit = switch (_metric) {
      _Metric.bodyFat => '%',
      _Metric.waist => units.lengthUnit,
      _ => units.weightUnit,
    };

    final kg = state.progress.currentWeightKg ?? profile?.weightKg;
    final cm = profile?.heightCm;
    final age = profile == null
        ? null
        : (DateTime.now().difference(profile.birthDate).inDays / 365.25)
              .floor();
    final bmr = (kg != null && cm != null && age != null)
        ? 10 * kg +
              6.25 * cm -
              5 * age +
              (profile?.sex == Sex.female ? -161 : 5)
        : null;
    final bmi = (kg != null && cm != null) ? kg / math.pow(cm / 100, 2) : null;
    final lean = state.measurements
        .where((e) => e.weightKg != null && e.bodyFatPercent != null)
        .firstOrNull;

    final delta = points.length >= 2 ? points.last.$2 - points.first.$2 : null;
    return VSubPage(
      title: 'Body\ncomposition',
      maxWidth: 720,
      action: _metric == _Metric.leanMass
          ? null
          : VButton('+ Log', height: 36, onPressed: () => _log(context, units)),
      children: [
        VChipRow<_Metric>(
          options: {for (final m in _Metric.values) m: m.label},
          selected: _metric,
          onChanged: (m) => setState(() => _metric = m),
        ),
        VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              VLabel(
                delta == null
                    ? 'Last $_range days'
                    : '${delta <= 0 ? '−' : '+'}${delta.abs().toStringAsFixed(1)} $unit over $_range days',
              ),
              Text.rich(
                TextSpan(
                  text: points.isEmpty
                      ? '—'
                      : points.last.$2.toStringAsFixed(1),
                  children: [
                    if (points.isNotEmpty)
                      TextSpan(
                        text: ' $unit',
                        style: VeyroText.display(22, color: v.mute),
                      ),
                  ],
                ),
                style: VeyroText.display(64, height: .95),
              ),
              const SizedBox(height: 8),
              if (points.length >= 2)
                VLinePlot(
                  values: [for (final p in points) p.$2],
                  height: 140,
                  fill: true,
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    points.isEmpty
                        ? (_metric == _Metric.leanMass
                              ? 'Log weight and body fat together to see lean mass.'
                              : 'No ${_metric.label.toLowerCase()} logged in this range. Tap + Log to add one.')
                        : 'Log at least one more entry to see a trend.',
                    style: VeyroText.body(13.5, color: v.mute),
                  ),
                ),
              if (points.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    '${points.length} ${points.length == 1 ? 'entry' : 'entries'} · latest ${DateFormat.MMMd().format(points.last.$1)}',
                    style: VeyroText.body(12, color: v.mute),
                  ),
                ),
              const SizedBox(height: 8),
              VSegmented<int>(
                options: const {30: '30', 90: '90', 180: '180'},
                selected: _range,
                height: 34,
                onChanged: (r) => setState(() => _range = r),
              ),
            ],
          ),
        ),
        VGrid2(
          children: [
            VStatTile(
              label: 'BMR',
              value: bmr == null ? '—' : thousands(bmr),
              suffix: bmr == null ? null : 'kcal',
            ),
            VStatTile(
              label: 'TDEE',
              value: bmr == null ? '—' : thousands(bmr * 1.55),
              suffix: bmr == null ? null : 'kcal',
            ),
            VStatTile(
              label: 'Lean mass',
              value: lean == null
                  ? '—'
                  : '${units.fw(lean.weightKg! * (1 - lean.bodyFatPercent! / 100))} ${units.weightUnit}',
            ),
            VStatTile(
              label: 'BMI',
              value: bmi == null ? '—' : bmi.toStringAsFixed(1),
            ),
          ],
        ),
        Text(
          'TDEE assumes moderate activity. Estimates only. Not medical advice.',
          style: VeyroText.body(12, color: v.mute),
        ),
      ],
    );
  }

  Future<void> _log(BuildContext context, units) async {
    final cubit = context.read<BodyMetricsCubit>();
    final (title, unit) = switch (_metric) {
      _Metric.weight => ('Log weight', units.weightUnit as String),
      _Metric.bodyFat => ('Log body fat', '%'),
      _ => ('Log waist', units.lengthUnit as String),
    };
    final text = await showVeyroInputSheet(
      context,
      title: title,
      label: _metric.label,
      unit: unit,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
    );
    final n = tryParseDecimal(text);
    if (n == null) return;
    await cubit.log(switch (_metric) {
      _Metric.weight => LogBodyMeasurementParams(
        weightKg: UnitConverter.weightFromDisplay(n, units),
      ),
      _Metric.bodyFat => LogBodyMeasurementParams(bodyFatPercent: n),
      _ => LogBodyMeasurementParams(
        waistCm: UnitConverter.lengthFromDisplay(n, units),
      ),
    });
  }
}
