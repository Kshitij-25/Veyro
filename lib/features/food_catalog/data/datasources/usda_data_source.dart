import 'dart:convert';

import 'package:fitness_trakcer/core/error/failure_exception.dart';
import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/features/food_catalog/domain/entities/catalog_food.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

/// USDA FoodData Central: generic and raw foods (Foundation and SR Legacy
/// data, per 100 g). Uses the shared `DEMO_KEY` (heavily rate limited) unless
/// a key is passed with `--dart-define=USDA_API_KEY=...`.
@lazySingleton
class UsdaDataSource {
  UsdaDataSource(this._client);

  final http.Client _client;

  static const _apiKey = String.fromEnvironment(
    'USDA_API_KEY',
    defaultValue: 'DEMO_KEY',
  );
  static const _timeout = Duration(seconds: 12);

  Future<List<CatalogFood>> search(String query) async {
    final uri = Uri.https('api.nal.usda.gov', '/fdc/v1/foods/search', {
      'api_key': _apiKey,
      'query': query,
      'pageSize': '10',
      'dataType': 'Foundation,SR Legacy',
    });
    final response = await _client.get(uri).timeout(_timeout);
    if (response.statusCode == 429) {
      throw const FailureException(NetworkFailure('USDA rate limit reached.'));
    }
    if (response.statusCode != 200) {
      throw const FailureException(NetworkFailure('USDA is unavailable.'));
    }
    final foods = (jsonDecode(response.body) as Map<String, dynamic>)['foods'];
    return [
      for (final item in (foods as List? ?? const []))
        ?parse(item as Map<String, dynamic>),
    ];
  }

  static CatalogFood? parse(Map<String, dynamic> json) {
    final id = json['fdcId'];
    final description = '${json['description'] ?? ''}'.trim();
    if (id == null || description.isEmpty) return null;
    final values = <String, double>{
      for (final n in (json['foodNutrients'] as List? ?? const []))
        if ((n as Map<String, dynamic>)['nutrientNumber'] != null &&
            n['value'] is num)
          '${n['nutrientNumber']}': (n['value'] as num).toDouble(),
    };
    // 208 is energy in kcal; Foundation foods may only carry the Atwater
    // estimates (957 general factors, 958 specific factors).
    final kcal = values['208'] ?? values['957'] ?? values['958'];
    if (kcal == null) return null;
    return CatalogFood(
      id: 'usda:$id',
      source: FoodSource.usda,
      name: _tidy(description),
      servingLabel: '100 g',
      kcal: kcal,
      protein: values['203'] ?? 0,
      carbs: values['205'] ?? 0,
      fat: values['204'] ?? 0,
    );
  }

  static String _tidy(String text) => text == text.toUpperCase()
      ? text
            .toLowerCase()
            .split(' ')
            .map(
              (w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}',
            )
            .join(' ')
      : text;
}
