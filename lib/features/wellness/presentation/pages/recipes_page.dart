import 'package:fitness_trakcer/core/router/app_routes.dart';
import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/widgets/veyro_charts.dart';
import 'package:fitness_trakcer/core/widgets/veyro_extras.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_store.dart';
import 'package:flutter/material.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    return WellnessBuilder(
      builder: (context, store) {
        final list = WellnessStore.recipes
            .where((r) => _filter == 'All' || r.tags.contains(_filter))
            .toList();
        return VSubPage(
          title: 'Recipes',
          maxWidth: 840,
          children: [
            VChipRow<String>(
              options: const {
                'All': 'All',
                'High protein': 'High protein',
                'Quick': 'Quick',
                'Vegetarian': 'Vegetarian',
              },
              selected: _filter,
              onChanged: (f) => setState(() => _filter = f),
            ),
            VGrid2(
              gap: 10,
              children: [
                for (final r in list)
                  VCard(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const VPlaceholder('recipe photo'),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    r.name.toUpperCase(),
                                    style: VeyroText.display(24),
                                  ),
                                  Text(
                                    '${r.minutes} min · ${r.kcal} kcal · P ${r.protein} g',
                                    style: VeyroText.body(12.5, color: v.mute),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => store.toggleRecipe(r.name),
                              icon: Icon(
                                store.savedRecipes.contains(r.name)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: v.acc,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        VButton(
                          'Log to dinner',
                          style: VButtonStyle.soft,
                          height: 40,
                          radius: 12,
                          expand: true,
                          onPressed: () {
                            store.logFood(
                              'Dinner',
                              FoodItem(
                                r.name,
                                '1 serving',
                                r.kcal,
                                r.protein,
                                40,
                                15,
                              ),
                              1,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${r.name} added to Dinner'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

/// Used by the Fuel tab to jump back from sub-pages.
void backToFuel(BuildContext context) =>
    veyroBack(context, fallback: AppRoutes.fuel);
