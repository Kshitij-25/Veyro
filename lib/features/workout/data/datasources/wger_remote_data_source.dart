import 'dart:async';
import 'dart:convert';

import 'package:fitness_trakcer/core/error/failure_exception.dart';
import 'package:fitness_trakcer/core/error/failures.dart';
import 'package:fitness_trakcer/core/network/api_headers.dart';
import 'package:fitness_trakcer/features/workout/data/models/wger_exercise_dto.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

/// Client for the public wger exercise API (https://wger.de/api/v2/).
@lazySingleton
class WgerRemoteDataSource {
  const WgerRemoteDataSource(this._client);

  static const _firstPage =
      'https://wger.de/api/v2/exerciseinfo/?language=2&limit=100';

  /// Guards against a misbehaving server that never ends pagination.
  static const _maxPages = 30;

  final http.Client _client;

  /// Downloads every English exercise (about 900 at the time of writing).
  Future<List<WgerExerciseDto>> fetchAll() async {
    final result = <WgerExerciseDto>[];
    String? url = _firstPage;
    var pages = 0;
    while (url != null && pages < _maxPages) {
      final json = await _getJson(url);
      for (final item in (json['results'] as List<dynamic>? ?? const [])) {
        result.add(WgerExerciseDto.fromJson(item as Map<String, dynamic>));
      }
      final next = json['next'] as String?;
      url = next?.replaceFirst('http://', 'https://');
      pages++;
    }
    return result;
  }

  Future<Map<String, dynamic>> _getJson(String url) async {
    try {
      final response = await _client
          .get(Uri.parse(url), headers: apiHeaders)
          .timeout(apiTimeout);
      if (response.statusCode != 200) {
        throw FailureException(
          NetworkFailure(
            'The exercise service returned ${response.statusCode}.',
          ),
        );
      }
      return jsonDecode(utf8.decode(response.bodyBytes))
          as Map<String, dynamic>;
    } on FailureException {
      rethrow;
    } on TimeoutException {
      throw const FailureException(
        NetworkFailure('The exercise service took too long to respond.'),
      );
    } on http.ClientException {
      throw const FailureException(NetworkFailure());
    } on FormatException {
      throw const FailureException(
        NetworkFailure('The exercise service sent an unexpected response.'),
      );
    }
  }
}
