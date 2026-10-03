import 'package:fitness_trakcer/features/food_catalog/domain/entities/catalog_food.dart';
import 'package:fitness_trakcer/features/wellness/presentation/wellness_store.dart';

extension CatalogFoodToDiaryItem on CatalogFood {
  /// The food as logged in the diary (whole-number nutrition per serving).
  FoodItem toFoodItem() => FoodItem(
    brand == null || name.toLowerCase().contains(brand!.toLowerCase())
        ? name
        : '$name ($brand)',
    servingLabel,
    kcal.round(),
    protein.round(),
    carbs.round(),
    fat.round(),
  );
}
