import 'package:fitness_trakcer/core/layout/content_constraint.dart';
import 'package:fitness_trakcer/core/router/app_routes.dart';
import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/widgets/veyro_charts.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/profile/presentation/unit_system_context.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_format.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

const waterBlue = Color(0xFF2F6FE5);
const fatYellow = Color(0xFFE5A100);

/// Root of the Food tab: calories, macros, fasting, water and the food diary.
class FoodPage extends StatelessWidget {
  const FoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ContentConstraint(
          maxWidth: 1100,
          child: WellnessBuilder(
            builder: (context, store) => ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
              children: [
                VTitle(
                  'Food',
                  kicker: DateFormat('EEEE, MMM d').format(DateTime.now()),
                  trailing: Row(
                    children: [
                      VButton(
                        'Targets',
                        style: VButtonStyle.card,
                        height: 36,
                        onPressed: () =>
                            context.push(AppRoutes.nutritionTargets),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                VTwoColumn(
                  left: [
                    _CalorieHero(store: store),
                    _MacroCard(store: store),
                    const _FastingTile(),
                    _WaterCard(store: store),
                  ],
                  right: [
                    for (final meal in WellnessStore.mealNames)
                      _MealCard(meal: meal, store: store),
                    VButton(
                      'Scan barcode',
                      style: VButtonStyle.ink,
                      height: 50,
                      radius: 16,
                      expand: true,
                      onPressed: () => context.push(AppRoutes.scan),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CalorieHero extends StatelessWidget {
  const _CalorieHero({required this.store});

  final WellnessStore store;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final remain = store.remainingKcal;
    Widget stat(String value, String label) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: VeyroText.display(28, color: v.bg)),
        Text(
          label,
          style: VeyroText.body(11, color: v.bg.withValues(alpha: .6)),
        ),
      ],
    );
    return VCard(
      color: v.ink,
      radius: 26,
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          VRing(
            fraction: store.eatenKcal / (store.kcalGoal + store.exerciseKcal),
            color: v.acc,
            size: 112,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  thousands(remain),
                  style: VeyroText.display(28, color: v.bg),
                ),
                Text(
                  'kcal left',
                  style: VeyroText.body(10, color: v.bg.withValues(alpha: .6)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                stat(thousands(store.eatenKcal), 'Eaten'),
                const SizedBox(height: 8),
                stat('${store.exerciseKcal}', 'Exercise'),
                const SizedBox(height: 8),
                stat(thousands(store.kcalGoal), 'Goal'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MacroCard extends StatelessWidget {
  const _MacroCard({required this.store});

  final WellnessStore store;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final rows = [
      ('Protein', store.eatenProtein, store.proteinGoal, v.acc),
      ('Carbs', store.eatenCarbs, store.carbGoal, waterBlue),
      ('Fat', store.eatenFat, store.fatGoal, fatYellow),
    ];
    return VCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VLabel('Macros'),
          const SizedBox(height: 10),
          for (final r in rows) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(r.$1, style: VeyroText.body(13, weight: FontWeight.w600)),
                Text(
                  '${r.$2.round()} / ${r.$3} g',
                  style: VeyroText.body(13, color: v.mute),
                ),
              ],
            ),
            const SizedBox(height: 4),
            _Bar(value: r.$2 / r.$3, color: r.$4),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.value, required this.color}) : height = 8;

  final double value;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(height / 2),
    child: LinearProgressIndicator(
      value: value.clamp(0.0, 1.0),
      minHeight: height,
      backgroundColor: context.veyro.bg,
      valueColor: AlwaysStoppedAnimation(color),
    ),
  );
}

class _FastingTile extends StatelessWidget {
  const _FastingTile();

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return WellnessBuilder(
      builder: (context, store) => VCard(
        onTap: () => context.push(AppRoutes.fasting),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const VLabel('Intermittent fasting'),
                  if (store.fastOn)
                    StreamBuilder<int>(
                      stream: Stream.periodic(
                        const Duration(seconds: 1),
                        (i) => i,
                      ),
                      builder: (context, _) => Text.rich(
                        TextSpan(
                          text: clockText(
                            DateTime.now()
                                .difference(store.fastStart)
                                .inSeconds,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  ' of ${store.fastHours}:${24 - store.fastHours}',
                              style: VeyroText.body(14, color: v.mute),
                            ),
                          ],
                        ),
                        style: VeyroText.display(32),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        'Not fasting · start a fast',
                        style: VeyroText.body(17, weight: FontWeight.w700),
                      ),
                    ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: v.mute),
          ],
        ),
      ),
    );
  }
}

class _WaterCard extends StatelessWidget {
  const _WaterCard({required this.store});

  final WellnessStore store;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final units = context.unitSystem;
    final imp = units.isImperial;
    Widget add(String label, int ml) => Expanded(
      child: SizedBox(
        height: 38,
        child: FilledButton(
          onPressed: () => store.addWater(ml),
          style: FilledButton.styleFrom(
            backgroundColor: v.bg,
            foregroundColor: v.ink,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: VeyroText.body(13, weight: FontWeight.w600),
          ),
          child: Text(label),
        ),
      ),
    );
    return VCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const VLabel('Water'),
              Text(
                '${thousands(units.waterDisplay(store.waterMl))} / '
                '${thousands(units.waterDisplay(store.waterGoalMl))} ${units.waterUnit}',
                style: VeyroText.display(22),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (var i = 0; i < 10; i++)
                Expanded(
                  child: Container(
                    height: 34,
                    margin: EdgeInsets.only(right: i == 9 ? 0 : 4),
                    decoration: BoxDecoration(
                      color: store.waterMl >= (i + 1) * 250 ? waterBlue : v.bg,
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              add(imp ? '+8 oz' : '+250 ml', 250),
              const SizedBox(width: 8),
              add(imp ? '+16 oz' : '+500 ml', 500),
              const SizedBox(width: 8),
              add(imp ? '−8 oz' : '−250 ml', -250),
            ],
          ),
        ],
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  const _MealCard({required this.meal, required this.store});

  final String meal;
  final WellnessStore store;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final items = store.meals[meal]!;
    final kcal = items.fold(0.0, (a, b) => a + b.kcal);
    return VCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(meal.toUpperCase(), style: VeyroText.display(26)),
                  Text(
                    '${kcal.round()} kcal',
                    style: VeyroText.body(12, color: v.mute),
                  ),
                ],
              ),
              VButton(
                '+ Add',
                height: 34,
                onPressed: () => context.push(
                  '${AppRoutes.foodSearch}?meal=${Uri.encodeComponent(meal)}',
                ),
              ),
            ],
          ),
          for (final (i, it) in items.indexed)
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: v.line)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          it.food.name,
                          style: VeyroText.body(15, weight: FontWeight.w600),
                        ),
                        Text(
                          '${it.quantity != 1 ? '${_q(it.quantity)} × ' : ''}${it.food.serving} · P ${it.p.round()} g',
                          style: VeyroText.body(12, color: v.mute),
                        ),
                      ],
                    ),
                  ),
                  Text('${it.kcal.round()}', style: VeyroText.display(20)),
                  IconButton(
                    onPressed: () => store.removeFood(meal, i),
                    icon: Icon(Icons.close, size: 18, color: v.mute),
                  ),
                ],
              ),
            ),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Nothing logged yet',
                style: VeyroText.body(13, color: v.mute),
              ),
            ),
        ],
      ),
    );
  }

  static String _q(double q) => q == q.roundToDouble() ? '${q.round()}' : '$q';
}
