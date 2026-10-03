import 'package:equatable/equatable.dart';

enum FoodSource {
  openFoodFacts('Open Food Facts'),
  usda('USDA'),
  custom('Mine');

  const FoodSource(this.label);

  final String label;
}

/// A food with nutrition for one [servingLabel] (e.g. "100 g", "1 bar (40 g)").
class CatalogFood extends Equatable {
  const CatalogFood({
    required this.id,
    required this.source,
    required this.name,
    required this.servingLabel,
    required this.kcal,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.brand,
    this.isFavorite = false,
    this.lastUsedAt,
  });

  final String id;
  final FoodSource source;
  final String name;
  final String? brand;
  final String servingLabel;
  final double kcal;
  final double protein;
  final double carbs;
  final double fat;
  final bool isFavorite;
  final DateTime? lastUsedAt;

  /// The brand when it adds information (not already part of the name).
  String? get extraBrand =>
      brand == null || name.toLowerCase().contains(brand!.toLowerCase())
      ? null
      : brand;

  CatalogFood copyWith({bool? isFavorite, DateTime? lastUsedAt}) => CatalogFood(
    id: id,
    source: source,
    name: name,
    brand: brand,
    servingLabel: servingLabel,
    kcal: kcal,
    protein: protein,
    carbs: carbs,
    fat: fat,
    isFavorite: isFavorite ?? this.isFavorite,
    lastUsedAt: lastUsedAt ?? this.lastUsedAt,
  );

  @override
  List<Object?> get props => [
    id,
    source,
    name,
    brand,
    servingLabel,
    kcal,
    protein,
    carbs,
    fat,
    isFavorite,
    lastUsedAt,
  ];
}

/// What a search found, plus which online sources couldn't be reached.
class FoodSearchResult {
  const FoodSearchResult(this.foods, this.unreachable);

  final List<CatalogFood> foods;
  final List<String> unreachable;
}
