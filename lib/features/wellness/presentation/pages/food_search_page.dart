import 'package:fitness_trakcer/core/layout/content_constraint.dart';
import 'package:fitness_trakcer/core/router/app_routes.dart';
import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/widgets/veyro_extras.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Search the sample food catalogue and log a food into a meal.
class FoodSearchPage extends StatefulWidget {
  const FoodSearchPage({this.initialMeal = 'Snacks', super.key});

  final String initialMeal;

  @override
  State<FoodSearchPage> createState() => _FoodSearchPageState();
}

class _FoodSearchPageState extends State<FoodSearchPage> {
  late String _meal = widget.initialMeal;
  String _query = '';
  String _tab = 'All';

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final q = _query.toLowerCase();
    var list = WellnessStore.foods.indexed
        .where((e) => e.$2.name.toLowerCase().contains(q))
        .toList();
    if (q.isEmpty) {
      if (_tab == 'Recent') list = list.take(6).toList();
      if (_tab == 'Favorites') list = list.where((e) => e.$1 % 3 == 0).toList();
    }
    return Scaffold(
      body: SafeArea(
        child: ContentConstraint(
          maxWidth: 720,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  height: 52,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      VBackButton(
                        onPressed: () =>
                            veyroBack(context, fallback: AppRoutes.fuel),
                      ),
                      VButton(
                        'Scan',
                        style: VButtonStyle.card,
                        height: 36,
                        onPressed: () => context.go(AppRoutes.scan),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                  children: [
                    const VTitle('Log food', size: 46),
                    const SizedBox(height: 4),
                    Text(
                      'Adding to $_meal',
                      style: VeyroText.body(13, color: v.mute),
                    ),
                    const SizedBox(height: 12),
                    VChipRow<String>(
                      options: {for (final m in WellnessStore.mealNames) m: m},
                      selected: _meal,
                      onChanged: (m) => setState(() => _meal = m),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      onChanged: (t) => setState(() => _query = t),
                      style: VeyroText.body(15, color: v.ink),
                      decoration: const InputDecoration(
                        hintText: 'Search foods',
                        contentPadding: EdgeInsets.symmetric(horizontal: 14),
                      ),
                    ),
                    const SizedBox(height: 12),
                    VChipRow<String>(
                      options: const {
                        'All': 'All',
                        'Recent': 'Recent',
                        'Favorites': 'Favorites',
                      },
                      selected: _tab,
                      onChanged: (t) => setState(() => _tab = t),
                    ),
                    const SizedBox(height: 12),
                    if (list.isEmpty)
                      const VEmpty('No foods found.')
                    else
                      VCard(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            for (final (i, e) in list.indexed)
                              InkWell(
                                onTap: () =>
                                    showFoodSheet(context, e.$2, _meal),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    border: i == 0
                                        ? null
                                        : Border(
                                            top: BorderSide(color: v.line),
                                          ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              e.$2.name,
                                              style: VeyroText.body(
                                                15.5,
                                                weight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              '${e.$2.serving} · P ${e.$2.p} C ${e.$2.c} F ${e.$2.f}',
                                              style: VeyroText.body(
                                                12,
                                                color: v.mute,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '${e.$2.kcal}',
                                        style: VeyroText.display(22),
                                      ),
                                      const SizedBox(width: 12),
                                      Container(
                                        width: 30,
                                        height: 30,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: v.acc,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          '+',
                                          style: VeyroText.body(
                                            18,
                                            weight: FontWeight.w800,
                                            color: VeyroColors.onAccent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Serving sheet for one food; adds it to the diary and returns to Fuel.
Future<void> showFoodSheet(BuildContext context, FoodItem food, String meal) {
  final v = context.veyro;
  var servings = 1.0;
  var target = meal;
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: v.card,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (sheetContext) => StatefulBuilder(
      builder: (sheetContext, setState) {
        Widget macro(String value, String label) => Expanded(
          child: Column(
            children: [
              Text(value, style: VeyroText.display(28)),
              Text(label, style: VeyroText.body(11, color: v.mute)),
            ],
          ),
        );
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(food.name.toUpperCase(), style: VeyroText.display(30)),
                Text(
                  '${food.serving} per serving',
                  style: VeyroText.body(13, color: v.mute),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    macro('${(food.kcal * servings).round()}', 'kcal'),
                    macro('${(food.p * servings).round()}', 'protein g'),
                    macro('${(food.c * servings).round()}', 'carbs g'),
                    macro('${(food.f * servings).round()}', 'fat g'),
                  ],
                ),
                const SizedBox(height: 12),
                VStepper(
                  label: 'Servings',
                  value: servings == servings.roundToDouble()
                      ? '${servings.round()}'
                      : '$servings',
                  onMinus: () => setState(
                    () => servings = (servings - 0.5).clamp(0.5, 99),
                  ),
                  onPlus: () => setState(() => servings += 0.5),
                ),
                const SizedBox(height: 12),
                VChipRow<String>(
                  options: {for (final m in WellnessStore.mealNames) m: m},
                  selected: target,
                  onChanged: (m) => setState(() => target = m),
                  onCard: true,
                ),
                const SizedBox(height: 12),
                VButton(
                  'Add to $target',
                  height: 54,
                  radius: 16,
                  expand: true,
                  onPressed: () {
                    WellnessStore.instance.logFood(target, food, servings);
                    Navigator.pop(sheetContext);
                    context.go(AppRoutes.fuel);
                  },
                ),
                TextButton(
                  onPressed: () => Navigator.pop(sheetContext),
                  child: Text(
                    'Cancel',
                    style: VeyroText.body(
                      15,
                      weight: FontWeight.w600,
                      color: v.mute,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
