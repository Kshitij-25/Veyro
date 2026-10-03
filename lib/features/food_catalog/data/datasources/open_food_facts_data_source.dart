import 'dart:convert';

import 'package:fitness_trakcer/core/error/failure_exception.dart';
import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/features/food_catalog/domain/entities/catalog_food.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

/// Open Food Facts: packaged foods, by name or barcode. Free, no key. Data is
/// community-contributed (ODbL), so quality varies.
@lazySingleton
class OpenFoodFactsDataSource {
  OpenFoodFactsDataSource(this._client);

  final http.Client _client;

  static const _fields =
      'code,product_name,brands,nutriments,serving_size,serving_quantity';
  static const _headers = {'User-Agent': 'Veyro/1.0 (Flutter fitness tracker)'};
  static const _timeout = Duration(seconds: 12);

  Future<List<CatalogFood>> search(String query) async {
    final uri = Uri.https('search.openfoodfacts.org', '/search', {
      'q': query,
      'page_size': '15',
      'fields': _fields,
      'langs': 'en',
    });
    final response = await _client
        .get(uri, headers: _headers)
        .timeout(_timeout);
    if (response.statusCode != 200) {
      throw const FailureException(
        NetworkFailure('Open Food Facts is unavailable.'),
      );
    }
    final hits = (jsonDecode(response.body) as Map<String, dynamic>)['hits'];
    return [
      for (final hit in (hits as List? ?? const []))
        ?parse(hit as Map<String, dynamic>),
    ];
  }

  /// `null` when the barcode isn't in the database.
  Future<CatalogFood?> byBarcode(String barcode) async {
    final uri = Uri.https(
      'world.openfoodfacts.org',
      '/api/v2/product/$barcode.json',
      {'fields': _fields},
    );
    final response = await _client
        .get(uri, headers: _headers)
        .timeout(_timeout);
    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) {
      throw const FailureException(
        NetworkFailure('Open Food Facts is unavailable.'),
      );
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (body['status'] != 1) return null;
    return parse(body['product'] as Map<String, dynamic>);
  }

  /// Maps one product to a [CatalogFood], or `null` if it has no name or
  /// energy value.
  static CatalogFood? parse(Map<String, dynamic> json) {
    final code = '${json['code'] ?? ''}';
    final name = '${json['product_name'] ?? ''}'.trim();
    if (code.isEmpty || name.isEmpty) return null;
    final n = (json['nutriments'] as Map<String, dynamic>?) ?? const {};
    double? num100(String key) => (n[key] as num?)?.toDouble();
    var kcal = num100('energy-kcal_100g');
    if (kcal == null) {
      final kj = num100('energy-kj_100g') ?? num100('energy_100g');
      if (kj != null) kcal = kj / 4.184;
    }
    if (kcal == null) return null;
    final grams = double.tryParse('${json['serving_quantity'] ?? ''}');
    final hasServing = grams != null && grams > 0;
    final f = hasServing ? grams / 100 : 1.0;
    final sizeText = '${json['serving_size'] ?? ''}'.trim();
    final brands = json['brands'];
    final brand = brands is List
        ? (brands.isEmpty ? null : '${brands.first}')
        : (brands == null || '$brands'.trim().isEmpty
              ? null
              : '$brands'.split(',').first.trim());
    return CatalogFood(
      id: 'off:$code',
      source: FoodSource.openFoodFacts,
      name: name,
      brand: brand,
      servingLabel: hasServing
          ? (sizeText.isEmpty ? '${grams.round()} g' : sizeText)
          : '100 g',
      kcal: kcal * f,
      protein: (num100('proteins_100g') ?? 0) * f,
      carbs: (num100('carbohydrates_100g') ?? 0) * f,
      fat: (num100('fat_100g') ?? 0) * f,
    );
  }
}
