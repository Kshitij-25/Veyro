import 'dart:math' as math;

import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/units/unit_system.dart';
import 'package:fitness_trakcer/core/widgets/veyro_extras.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/profile/domain/entities/sex.dart';
import 'package:fitness_trakcer/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 1RM, plate, calorie and pace calculators.
class ToolsPage extends StatefulWidget {
  const ToolsPage({this.initialTab = '1RM', super.key});

  final String initialTab;

  @override
  State<ToolsPage> createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  late String _tab = widget.initialTab;
  String? _weight;
  String _reps = '5';
  String? _target;
  int _pace = 480;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final units = context.unitSystem;
    final imp = units == UnitSystem.imperial;
    final w = _weight ?? (imp ? '185' : '85');
    final target = _target ?? (imp ? '225' : '100');
    final profile = context.watch<ProfileCubit>().state.profile;
    final kg = profile?.weightKg ?? 80.0;
    final cm = profile?.heightCm ?? 178.0;
    final age = profile == null
        ? 35
        : (DateTime.now().difference(profile.birthDate).inDays / 365.25)
              .floor();
    final bmr =
        10 * kg + 6.25 * cm - 5 * age + (profile?.sex == Sex.female ? -161 : 5);

    Widget field(String label, String value, ValueChanged<String> onChanged) =>
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VLabel(label),
              const SizedBox(height: 6),
              TextFormField(
                initialValue: value,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                onChanged: (t) => setState(() => onChanged(t)),
                style: VeyroText.display(26, color: v.ink),
                decoration: InputDecoration(
                  fillColor: v.bg,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: v.line),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: v.line),
                  ),
                ),
              ),
            ],
          ),
        );

    final body = <Widget>[];
    if (_tab == '1RM') {
      final w1 = double.tryParse(w) ?? 0;
      final r1 = int.tryParse(_reps) ?? 1;
      final orm = r1 <= 1 ? w1 : w1 * (1 + r1 / 30);
      const reps = [1, 2, 4, 6, 8, 10, 12, 15, 18];
      body
        ..add(
          VCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    field(
                      'Weight (${units.weightUnit})',
                      w,
                      (t) => _weight = t,
                    ),
                    const SizedBox(width: 10),
                    field('Reps', _reps, (t) => _reps = t),
                  ],
                ),
                const SizedBox(height: 14),
                Center(
                  child: Column(
                    children: [
                      const VLabel('Estimated 1RM'),
                      Text.rich(
                        TextSpan(
                          text: '${orm.round()}',
                          children: [
                            TextSpan(
                              text: ' ${units.weightUnit}',
                              style: VeyroText.display(20, color: v.mute),
                            ),
                          ],
                        ),
                        style: VeyroText.display(72, height: 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
        ..add(
          VCard(
            child: Column(
              children: [
                for (final (i, p) in [
                  100,
                  95,
                  90,
                  85,
                  80,
                  75,
                  70,
                  65,
                  60,
                ].indexed)
                  Container(
                    height: 38,
                    decoration: BoxDecoration(
                      border: i == 0
                          ? null
                          : Border(top: BorderSide(color: v.line)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$p%',
                          style: VeyroText.body(15, weight: FontWeight.w700),
                        ),
                        Text(
                          '${(orm * p / 100).round()} ${units.weightUnit}',
                          style: VeyroText.display(22),
                        ),
                        Text(
                          '~${reps[i]} reps',
                          style: VeyroText.body(13, color: v.mute),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
    } else if (_tab == 'Plates') {
      final bar = imp ? 45.0 : 20.0;
      final plates = imp
          ? [45.0, 35.0, 25.0, 10.0, 5.0, 2.5]
          : [25.0, 20.0, 15.0, 10.0, 5.0, 2.5, 1.25];
      final colors = [
        VeyroColors.danger,
        const Color(0xFF2F6FE5),
        const Color(0xFFE5A100),
        VeyroColors.success,
        const Color(0xFFF5F3F0),
        const Color(0xFF9A948F),
        const Color(0xFF9A948F),
      ];
      var side = math.max(0.0, ((double.tryParse(target) ?? 0) - bar) / 2);
      final loaded = <(double, int)>[];
      for (final (i, p) in plates.indexed) {
        while (side >= p - 1e-9) {
          loaded.add((p, i));
          side -= p;
        }
      }
      body.add(
        VCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  field(
                    'Target (${units.weightUnit})',
                    target,
                    (t) => _target = t,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Bar ${bar.toStringAsFixed(0)} ${units.weightUnit} · ${side > .01 ? '${(side * 2).toStringAsFixed(1)} ${units.weightUnit} cannot be loaded with standard plates' : 'Per side'}',
                style: VeyroText.body(13, color: v.mute),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 10,
                      decoration: BoxDecoration(
                        color: v.mute,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    for (final p in loaded)
                      Container(
                        width: 16,
                        height: 34 + p.$1 / plates.first * 60,
                        margin: const EdgeInsets.only(left: 3),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colors[p.$2],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          p.$1 == p.$1.roundToDouble()
                              ? '${p.$1.round()}'
                              : '${p.$1}',
                          style: VeyroText.body(
                            9,
                            weight: FontWeight.w800,
                            color: VeyroColors.onAccent,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else if (_tab == 'Calories') {
      Widget rows(String title, List<(String, double)> items) => VCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VLabel(title),
            const SizedBox(height: 6),
            for (final r in items)
              VKeyValueRow(
                label: r.$1,
                value: Text(
                  '${thousands(r.$2)} kcal',
                  style: VeyroText.display(22),
                ),
              ),
          ],
        ),
      );
      body
        ..add(
          rows('Maintenance calories by activity', [
            ('Sedentary', bmr * 1.2),
            ('Lightly active', bmr * 1.375),
            ('Moderate', bmr * 1.55),
            ('Very active', bmr * 1.725),
          ]),
        )
        ..add(
          rows('Targets at moderate activity', [
            ('Cut', bmr * 1.55 - 500),
            ('Maintain', bmr * 1.55),
            ('Lean bulk', bmr * 1.55 + 300),
          ]),
        );
    } else {
      final unitKm = imp ? 1.609344 : 1.0;
      body
        ..add(
          VCard(
            child: VStepper(
              label: 'Pace',
              value: '${clockText(_pace)} /${units.distanceUnit}',
              onMinus: () => setState(() => _pace = math.max(180, _pace - 5)),
              onPlus: () => setState(() => _pace += 5),
            ),
          ),
        )
        ..add(
          VCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const VLabel('Projected finish'),
                const SizedBox(height: 6),
                for (final r in const [
                  ('5K', 5.0),
                  ('10K', 10.0),
                  ('Half marathon', 21.0975),
                  ('Marathon', 42.195),
                ])
                  VKeyValueRow(
                    label: r.$1,
                    value: Text(
                      clockText(_pace * r.$2 / unitKm),
                      style: VeyroText.display(24),
                    ),
                  ),
              ],
            ),
          ),
        );
    }
    return VSubPage(
      title: 'Calculators',
      maxWidth: 560,
      children: [
        VTabs<String>(
          options: const {
            '1RM': '1RM',
            'Plates': 'Plates',
            'Calories': 'Calories',
            'Pace': 'Pace',
          },
          selected: _tab,
          onChanged: (t) => setState(() => _tab = t),
        ),
        ...body,
      ],
    );
  }
}
