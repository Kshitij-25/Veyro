import 'package:drift/drift.dart';
import 'package:fitness_trakcer/core/database/app_database.dart';
import 'package:fitness_trakcer/core/utils/clock.dart';
import 'package:fitness_trakcer/core/utils/result.dart';
import 'package:fitness_trakcer/features/food_catalog/data/datasources/open_food_facts_data_source.dart';
import 'package:fitness_trakcer/features/food_catalog/data/datasources/saved_food_local_data_source.dart';
import 'package:fitness_trakcer/features/food_catalog/data/datasources/usda_data_source.dart';
import 'package:fitness_trakcer/features/food_catalog/domain/entities/catalog_food.dart';
import 'package:fitness_trakcer/features/food_catalog/domain/repositories/food_catalog_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: FoodCatalogRepository)
class FoodCatalogRepositoryImpl implements FoodCatalogRepository {
  const FoodCatalogRepositoryImpl(
    this._local,
    this._off,
    this._usda,
    this._clock,
  );

  final SavedFoodLocalDataSource _local;
  final OpenFoodFactsDataSource _off;
  final UsdaDataSource _usda;
  final Clock _clock;

  @override
  Future<Result<FoodSearchResult>> search(String query) => guard(() async {
    final unreachable = <String>[];
    Future<List<CatalogFood>> safe(
      String name,
      Future<List<CatalogFood>> Function() call,
    ) async {
      try {
        return await call();
      } on Object {
        unreachable.add(name);
        return const [];
      }
    }

    final results = await Future.wait([
      _local.search(query),
      safe('USDA', () => _usda.search(query)),
      safe('Open Food Facts', () => _off.search(query)),
    ]);
    final saved = (results[0] as List<SavedFoodRow>).map(_fromRow).toList();
    final byId = {for (final f in saved) f.id: f};
    final merged = <CatalogFood>[...saved];
    // Alternate generic (USDA) and packaged (Open Food Facts) results so both
    // show up near the top.
    final usda = results[1] as List<CatalogFood>;
    final off = results[2] as List<CatalogFood>;
    for (var i = 0; i < usda.length || i < off.length; i++) {
      for (final list in [usda, off]) {
        if (i < list.length && !byId.containsKey(list[i].id)) {
          // Keep the saved copy (it carries favourite / last-used state).
          merged.add(list[i]);
        }
      }
    }
    return FoodSearchResult(merged, unreachable);
  });

  @override
  Future<Result<CatalogFood?>> findByBarcode(String barcode) => guard(() async {
    final saved = await _local.get('off:$barcode');
    if (saved != null) return _fromRow(saved);
    return _off.byBarcode(barcode);
  });

  @override
  Stream<List<CatalogFood>> watchSaved() =>
      _local.watchAll().map((rows) => rows.map(_fromRow).toList());

  @override
  Future<Result<void>> markUsed(CatalogFood food) => guard(() async {
    final existing = await _local.get(food.id);
    await _local.upsert(
      _companion(
        food,
        favorite: existing?.isFavorite ?? food.isFavorite,
      ).copyWith(lastUsedAt: Value(_clock.now())),
    );
  });

  @override
  Future<Result<void>> setFavorite(
    CatalogFood food, {
    required bool favorite,
  }) => guard(() async {
    final existing = await _local.get(food.id);
    await _local.upsert(
      _companion(food, favorite: favorite).copyWith(
        lastUsedAt: Value(existing?.lastUsedAt),
        createdAt: Value(existing?.createdAt ?? _clock.now()),
      ),
    );
  });

  @override
  Future<Result<void>> saveCustom(CatalogFood food) =>
      guard(() => _local.upsert(_companion(food, favorite: food.isFavorite)));

  @override
  Future<Result<void>> deleteSaved(String id) => guard(() => _local.delete(id));

  SavedFoodsCompanion _companion(CatalogFood f, {required bool favorite}) =>
      SavedFoodsCompanion(
        id: Value(f.id),
        source: Value(f.source.name),
        name: Value(f.name),
        brand: Value(f.brand),
        servingLabel: Value(f.servingLabel),
        kcal: Value(f.kcal),
        protein: Value(f.protein),
        carbs: Value(f.carbs),
        fat: Value(f.fat),
        isFavorite: Value(favorite),
        createdAt: Value(_clock.now()),
      );

  CatalogFood _fromRow(SavedFoodRow r) => CatalogFood(
    id: r.id,
    source: FoodSource.values.firstWhere(
      (s) => s.name == r.source,
      orElse: () => FoodSource.custom,
    ),
    name: r.name,
    brand: r.brand,
    servingLabel: r.servingLabel,
    kcal: r.kcal,
    protein: r.protein,
    carbs: r.carbs,
    fat: r.fat,
    isFavorite: r.isFavorite,
    lastUsedAt: r.lastUsedAt,
  );
}
