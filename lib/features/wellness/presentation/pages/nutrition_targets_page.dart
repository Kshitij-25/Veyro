import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/widgets/veyro_extras.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:fitness_trakcer/features/wellness/presentation/pages/fuel_page.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_format.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_store.dart';
import 'package:flutter/material.dart';

class NutritionTargetsPage extends StatelessWidget {
  const NutritionTargetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final units = context.unitSystem;
    return WellnessBuilder(
      builder: (context, store) => VSubPage(
        title: 'Nutrition\ntargets',
        maxWidth: 560,
        children: [
          VCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                VStepper(
                  label: 'Daily calories',
                  value: thousands(store.kcalGoal),
                  onMinus: () => store.setKcalGoal(store.kcalGoal - 50),
                  onPlus: () => store.setKcalGoal(store.kcalGoal + 50),
                ),
                const SizedBox(height: 14),
                VChipRow<String>(
                  options: {
                    for (final p in WellnessStore.macroPresets.keys) p: p,
                  },
                  selected: store.macroPreset,
                  onChanged: (p) =>
                      store.setKcalGoal(store.kcalGoal, preset: p),
                  onCard: true,
                ),
                for (final r in [
                  ('Protein', store.proteinGoal, v.acc),
                  ('Carbs', store.carbGoal, waterBlue),
                  ('Fat', store.fatGoal, fatYellow),
                ])
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: v.line)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          r.$1,
                          style: VeyroText.body(15, weight: FontWeight.w600),
                        ),
                        Text(
                          '${r.$2} g',
                          style: VeyroText.display(26, color: r.$3),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          VCard(
            child: VStepper(
              label: 'Water goal (${units.waterUnit})',
              value: thousands(units.waterDisplay(store.waterGoalMl)),
              onMinus: () => store.setWaterGoal(store.waterGoalMl - 250),
              onPlus: () => store.setWaterGoal(store.waterGoalMl + 250),
            ),
          ),
        ],
      ),
    );
  }
}
