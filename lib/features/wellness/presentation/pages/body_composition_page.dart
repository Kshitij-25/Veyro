import 'dart:math' as math;

import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/units/unit_converter.dart';
import 'package:fitness_trakcer/core/widgets/veyro_charts.dart';
import 'package:fitness_trakcer/core/widgets/veyro_extras.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/profile/domain/entities/sex.dart';
import 'package:fitness_trakcer/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Body composition trends (sample series) and BMR/TDEE from the profile.
class BodyCompositionPage extends StatefulWidget {
  const BodyCompositionPage({super.key});

  @override
  State<BodyCompositionPage> createState() => _BodyCompositionPageState();
}

class _BodyCompositionPageState extends State<BodyCompositionPage> {
  String _metric = 'Weight';
  int _range = 90;

  static const _params = {
    'Body fat': [20.4, 17.8, .18],
    'Muscle mass': [34.6, 36.2, .12],
    'Waist': [88.0, 84.0, .5],
  };

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final units = context.unitSystem;
    final profile = context.watch<ProfileCubit>().state.profile;
    final kgNow = profile?.weightKg ?? 80.0;
    final cm = profile?.heightCm ?? 178.0;
    final age = profile == null
        ? 35
        : (DateTime.now().difference(profile.birthDate).inDays / 365.25)
              .floor();
    final female = profile?.sex == Sex.female;
    final bmr = 10 * kgNow + 6.25 * cm - 5 * age + (female ? -161 : 5);
    final bmi = kgNow / math.pow(cm / 100, 2);

    final points = <double>[];
    for (var off = _range; off >= 0; off -= 3) {
      final kg = 80.9 + (off / 180) * 6.1 + .35 * math.sin(off * 1.7);
      if (_metric == 'Weight') {
        points.add(UnitConverter.weightToDisplay(kg, units));
      } else {
        final p = _params[_metric]!;
        final base =
            p[1] + (p[0] - p[1]) * off / 180 + p[2] * math.sin(off * 1.3);
        points.add(switch (_metric) {
          'Muscle mass' => UnitConverter.weightToDisplay(base, units),
          'Waist' => UnitConverter.lengthToDisplay(base, units),
          _ => base,
        });
      }
    }
    final unit = switch (_metric) {
      'Body fat' => '%',
      'Waist' => units.lengthUnit,
      _ => units.weightUnit,
    };
    final delta = points.last - points.first;
    return VSubPage(
      title: 'Body\ncomposition',
      maxWidth: 720,
      children: [
        VChipRow<String>(
          options: const {
            'Weight': 'Weight',
            'Body fat': 'Body fat',
            'Muscle mass': 'Muscle mass',
            'Waist': 'Waist',
          },
          selected: _metric,
          onChanged: (m) => setState(() => _metric = m),
        ),
        VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              VLabel(
                '${delta <= 0 ? '−' : '+'}${delta.abs().toStringAsFixed(1)} $unit over $_range days',
              ),
              Text.rich(
                TextSpan(
                  text: points.last.toStringAsFixed(1),
                  children: [
                    TextSpan(
                      text: ' $unit',
                      style: VeyroText.display(22, color: v.mute),
                    ),
                  ],
                ),
                style: VeyroText.display(64, height: .95),
              ),
              const SizedBox(height: 8),
              VLinePlot(values: points, height: 140, fill: true),
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
            VStatTile(label: 'BMR', value: thousands(bmr), suffix: 'kcal'),
            VStatTile(
              label: 'TDEE',
              value: thousands(bmr * 1.55),
              suffix: 'kcal',
            ),
            VStatTile(
              label: 'Lean mass',
              value: '${units.fw(kgNow * (1 - .178))} ${units.weightUnit}',
            ),
            VStatTile(label: 'BMI', value: bmi.toStringAsFixed(1)),
          ],
        ),
        Text(
          'Estimates only. Not medical advice.',
          style: VeyroText.body(12, color: v.mute),
        ),
      ],
    );
  }
}
