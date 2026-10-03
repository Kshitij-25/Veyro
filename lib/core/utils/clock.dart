import 'package:injectable/injectable.dart';

/// Abstraction over the system clock so time-dependent logic stays explicit.
@lazySingleton
class Clock {
  const Clock();

  DateTime now() => DateTime.now();
}
