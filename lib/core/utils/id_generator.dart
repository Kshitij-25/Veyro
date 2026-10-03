import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

/// Produces unique identifiers for locally created entities.
@lazySingleton
class IdGenerator {
  const IdGenerator();

  static const _uuid = Uuid();

  String generate() => _uuid.v4();
}
