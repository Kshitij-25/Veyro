import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/food_catalog/domain/entities/catalog_food.dart';

abstract interface class FoodCatalogRepository {
  /// Searches saved foods, USDA (generic foods) and Open Food Facts
  /// (packaged foods). A source that fails is reported, not thrown.
  Future<Result<FoodSearchResult>> search(String query);

  /// Looks a barcode up. `null` data means the product isn't in the database.
  Future<Result<CatalogFood?>> findByBarcode(String barcode);

  /// Every saved food (logged, starred or custom).
  Stream<List<CatalogFood>> watchSaved();

  /// Stores the food (if new) and marks it as just used.
  Future<Result<void>> markUsed(CatalogFood food);

  Future<Result<void>> setFavorite(CatalogFood food, {required bool favorite});

  Future<Result<void>> saveCustom(CatalogFood food);

  Future<Result<void>> deleteSaved(String id);
}
