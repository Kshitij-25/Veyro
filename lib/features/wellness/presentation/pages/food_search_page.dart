import 'package:fitness_trakcer/core/layout/content_constraint.dart';
import 'package:fitness_trakcer/core/router/app_routes.dart';
import 'package:fitness_trakcer/core/theme/veyro_colors.dart';
import 'package:fitness_trakcer/core/theme/veyro_text.dart';
import 'package:fitness_trakcer/core/widgets/veyro_extras.dart';
import 'package:fitness_trakcer/core/widgets/veyro_widgets.dart';
import 'package:fitness_trakcer/features/food_catalog/domain/entities/catalog_food.dart';
import 'package:fitness_trakcer/features/food_catalog/presentation/cubit/food_catalog_cubit.dart';
import 'package:fitness_trakcer/features/wellness/presentation/catalog_food_mapper.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Search foods (saved, USDA generic, Open Food Facts packaged) and log one.
class FoodSearchPage extends StatefulWidget {
  const FoodSearchPage({this.initialMeal = 'Snacks', super.key});

  final String initialMeal;

  @override
  State<FoodSearchPage> createState() => _FoodSearchPageState();
}

class _FoodSearchPageState extends State<FoodSearchPage> {
  late String _meal = widget.initialMeal;
  String _tab = 'Search';

  List<CatalogFood> _list(FoodCatalogState s) {
    final q = s.query.trim().toLowerCase();
    bool match(CatalogFood f) =>
        q.isEmpty ||
        f.name.toLowerCase().contains(q) ||
        (f.brand?.toLowerCase().contains(q) ?? false);
    return switch (_tab) {
      'Recent' => s.recents.where(match).toList(),
      'Favorites' => s.favorites.where(match).toList(),
      'Mine' => s.mine.where(match).toList(),
      _ => s.results,
    };
  }

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final cubit = context.read<FoodCatalogCubit>();
    return Scaffold(
      body: SafeArea(
        child: ContentConstraint(
          maxWidth: 720,
          child: BlocBuilder<FoodCatalogCubit, FoodCatalogState>(
            builder: (context, state) {
              final list = _list(state);
              final searching = _tab == 'Search';
              return Column(
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
                                veyroBack(context, fallback: AppRoutes.food),
                          ),
                          VButton(
                            'Scan',
                            style: VButtonStyle.card,
                            height: 36,
                            onPressed: () => context.push(AppRoutes.scan),
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
                          options: {
                            for (final m in WellnessStore.mealNames) m: m,
                          },
                          selected: _meal,
                          onChanged: (m) => setState(() => _meal = m),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          onChanged: cubit.search,
                          style: VeyroText.body(15, color: v.ink),
                          decoration: const InputDecoration(
                            hintText: 'Search foods, e.g. banana or oats',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        VChipRow<String>(
                          options: const {
                            'Search': 'Search',
                            'Recent': 'Recent',
                            'Favorites': 'Favorites',
                            'Mine': 'Mine',
                          },
                          selected: _tab,
                          onChanged: (t) => setState(() => _tab = t),
                        ),
                        const SizedBox(height: 12),
                        if (searching && state.isSearching)
                          const Padding(
                            padding: EdgeInsets.all(24),
                            child: Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          )
                        else if (searching && state.query.trim().length < 2)
                          VCard(
                            child: Text(
                              'Type at least two letters. Results come from USDA FoodData Central (generic foods) and Open Food Facts (packaged products), plus foods you saved. Tap a food to set the amount.',
                              style: VeyroText.body(
                                13.5,
                                color: v.mute,
                                height: 1.4,
                              ),
                            ),
                          )
                        else if (list.isEmpty)
                          VEmpty(switch (_tab) {
                            'Recent' => 'Foods you log will show up here.',
                            'Favorites' => 'Star a food to keep it here.',
                            'Mine' => 'Foods you create will show up here.',
                            _ => 'No foods found.',
                          })
                        else
                          VCard(
                            padding: EdgeInsets.zero,
                            child: Column(
                              children: [
                                for (final (i, food) in list.indexed)
                                  _FoodRow(
                                    food: food,
                                    first: i == 0,
                                    onTap: () => showFoodSheet(
                                      context,
                                      food.toFoodItem(),
                                      _meal,
                                      onLogged: () => cubit.markUsed(food),
                                    ),
                                    onFavorite: () =>
                                        cubit.toggleFavorite(food),
                                    onDelete: food.source == FoodSource.custom
                                        ? () => _confirmDelete(cubit, food)
                                        : null,
                                  ),
                              ],
                            ),
                          ),
                        if (searching && state.unreachable.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Couldn\'t reach ${state.unreachable.join(' and ')}. Showing what was available.',
                            style: VeyroText.body(12, color: v.mute),
                          ),
                        ],
                        const SizedBox(height: 12),
                        VButton(
                          'Create a food',
                          style: VButtonStyle.soft,
                          expand: true,
                          onPressed: () => showCreateFoodSheet(context, cubit),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(FoodCatalogCubit cubit, CatalogFood food) async {
    final ok = await showVeyroConfirm(
      context,
      title: 'Delete ${food.name}?',
      message: 'It is removed from your saved foods. Days you already logged it keep their entries.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (ok) await cubit.deleteSaved(food);
  }
}

class _FoodRow extends StatelessWidget {
  const _FoodRow({
    required this.food,
    required this.first,
    required this.onTap,
    required this.onFavorite,
    this.onDelete,
  });

  final CatalogFood food;
  final bool first;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    final macros =
        'P ${food.protein.round()} C ${food.carbs.round()} F ${food.fat.round()}';
    return InkWell(
      onTap: onTap,
      onLongPress: onDelete,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: first ? null : Border(top: BorderSide(color: v.line)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: VeyroText.body(15.5, weight: FontWeight.w600),
                  ),
                  Text(
                    '${food.extraBrand == null ? '' : '${food.extraBrand} · '}${food.servingLabel} · $macros',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: VeyroText.body(12, color: v.mute),
                  ),
                  Text(
                    food.source.label,
                    style: VeyroText.body(10.5, color: v.mute),
                  ),
                ],
              ),
            ),
            Text('${food.kcal.round()}', style: VeyroText.display(22)),
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(
                food.isFavorite ? Icons.star : Icons.star_border,
                color: food.isFavorite ? v.acc : v.mute,
              ),
              onPressed: onFavorite,
            ),
            if (onDelete != null)
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(Icons.delete_outline, size: 20, color: v.mute),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet to create a food by hand (saved under "Mine").
Future<void> showCreateFoodSheet(
  BuildContext context,
  FoodCatalogCubit cubit,
) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useRootNavigator: true,
  backgroundColor: context.veyro.card,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
  ),
  builder: (_) => _CreateFoodSheet(cubit: cubit),
);

class _CreateFoodSheet extends StatefulWidget {
  const _CreateFoodSheet({required this.cubit});

  final FoodCatalogCubit cubit;

  @override
  State<_CreateFoodSheet> createState() => _CreateFoodSheetState();
}

class _CreateFoodSheetState extends State<_CreateFoodSheet> {
  final _name = TextEditingController();
  final _serving = TextEditingController(text: '1 serving');
  final _kcal = TextEditingController();
  final _protein = TextEditingController();
  final _carbs = TextEditingController();
  final _fat = TextEditingController();
  String? _error;

  @override
  void dispose() {
    for (final c in [_name, _serving, _kcal, _protein, _carbs, _fat]) {
      c.dispose();
    }
    super.dispose();
  }

  double _num(TextEditingController c) =>
      double.tryParse(c.text.trim().replaceAll(',', '.')) ?? 0;

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) {
      setState(() => _error = 'Give the food a name.');
      return;
    }
    if (_kcal.text.trim().isEmpty || _num(_kcal) < 0) {
      setState(() => _error = 'Enter the calories for one serving.');
      return;
    }
    final ok = await widget.cubit.createCustom(
      name: _name.text,
      serving: _serving.text,
      kcal: _num(_kcal),
      protein: _num(_protein),
      carbs: _num(_carbs),
      fat: _num(_fat),
    );
    if (ok && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final v = context.veyro;
    Widget field(String label, TextEditingController c, {bool number = true}) =>
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: TextField(
            controller: c,
            keyboardType: number
                ? const TextInputType.numberWithOptions(decimal: true)
                : TextInputType.text,
            decoration: InputDecoration(labelText: label, fillColor: v.bg),
          ),
        );
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          22,
          20,
          16 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('CREATE A FOOD', style: VeyroText.display(30)),
              const SizedBox(height: 12),
              field('Name', _name, number: false),
              field('Serving (e.g. 1 bar, 100 g)', _serving, number: false),
              field('Calories per serving', _kcal),
              Row(
                children: [
                  Expanded(child: field('Protein g', _protein)),
                  const SizedBox(width: 8),
                  Expanded(child: field('Carbs g', _carbs)),
                  const SizedBox(width: 8),
                  Expanded(child: field('Fat g', _fat)),
                ],
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    _error!,
                    style: VeyroText.body(12.5, color: VeyroColors.danger),
                  ),
                ),
              VButton('Save food', height: 52, expand: true, onPressed: _save),
              TextButton(
                onPressed: () => Navigator.pop(context),
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
      ),
    );
  }
}

/// Serving sheet for one food; adds it to the diary and returns to Food.
Future<void> showFoodSheet(
  BuildContext context,
  FoodItem food,
  String meal, {
  VoidCallback? onLogged,
}) {
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
                    onLogged?.call();
                    Navigator.pop(sheetContext);
                    context.go(AppRoutes.food);
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
