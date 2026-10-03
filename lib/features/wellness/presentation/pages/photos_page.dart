import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/units/unit_converter.dart';
import 'package:fitness_trakcer/core/widgets/veyro_charts.dart';
import 'package:fitness_trakcer/core/widgets/veyro_extras.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Progress photo check-ins; photos are placeholders (sample data).
class PhotosPage extends StatefulWidget {
  const PhotosPage({super.key});

  @override
  State<PhotosPage> createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  String _view = 'Grid';
  int _a = 0;
  int _b = 2;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final units = context.unitSystem;
    String kg(double x) =>
        '${UnitConverter.weightToDisplay(x, units).toStringAsFixed(1)} ${units.weightUnit}';
    return WellnessBuilder(
      builder: (context, store) {
        final list = store.checkIns;
        final a = list[_a.clamp(0, list.length - 1)];
        final b = list[_b.clamp(0, list.length - 1)];
        final diff = UnitConverter.weightToDisplay(a.kg - b.kg, units);
        return VSubPage(
          title: 'Progress\nphotos',
          maxWidth: 840,
          action: VButton(
            '+ Check-in',
            height: 36,
            onPressed: () {
              final latest =
                  context
                      .read<DashboardCubit>()
                      .state
                      .summary
                      ?.latestWeightKg ??
                  80;
              store.addCheckIn(latest);
              setState(() {
                _a = 0;
                _b = store.checkIns.length - 1;
              });
            },
          ),
          children: [
            VTabs<String>(
              options: const {'Grid': 'Grid', 'Compare': 'Compare'},
              selected: _view,
              onChanged: (t) => setState(() => _view = t),
            ),
            if (_view == 'Grid')
              for (final p in list)
                VCard(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            p.date.toUpperCase(),
                            style: VeyroText.display(22),
                          ),
                          Text(
                            kg(p.kg),
                            style: VeyroText.body(13, color: v.mute),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        children: [
                          Expanded(child: VPlaceholder('front', height: 150)),
                          SizedBox(width: 6),
                          Expanded(child: VPlaceholder('side', height: 150)),
                          SizedBox(width: 6),
                          Expanded(child: VPlaceholder('back', height: 150)),
                        ],
                      ),
                    ],
                  ),
                )
            else ...[
              VCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const VLabel('Before'),
                    const SizedBox(height: 8),
                    VChipRow<int>(
                      options: {for (final (i, c) in list.indexed) i: c.date},
                      selected: _b.clamp(0, list.length - 1),
                      onChanged: (i) => setState(() => _b = i),
                      onCard: true,
                    ),
                    const SizedBox(height: 12),
                    const VLabel('After'),
                    const SizedBox(height: 8),
                    VChipRow<int>(
                      options: {for (final (i, c) in list.indexed) i: c.date},
                      selected: _a.clamp(0, list.length - 1),
                      onChanged: (i) => setState(() => _a = i),
                      onCard: true,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        VPlaceholder('${b.date} front', height: 260),
                        const SizedBox(height: 4),
                        Text(kg(b.kg), style: VeyroText.display(20)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      children: [
                        VPlaceholder('${a.date} front', height: 260),
                        const SizedBox(height: 4),
                        Text(kg(a.kg), style: VeyroText.display(20)),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                '${diff <= 0 ? '−' : '+'}${diff.abs().toStringAsFixed(1)} ${units.weightUnit} between check-ins',
                textAlign: TextAlign.center,
                style: VeyroText.body(13, color: v.mute),
              ),
            ],
            Text(
              'Photos stay on this device.',
              textAlign: TextAlign.center,
              style: VeyroText.body(12, color: v.mute),
            ),
          ],
        );
      },
    );
  }
}
