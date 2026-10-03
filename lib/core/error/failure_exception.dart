import 'package:fitness_trakcer/core/error/failures.dart';

/// Thrown from data sources / repositories when a [Failure] needs to unwind
/// through several layers before being converted into a `Result`.
class FailureException implements Exception {
  const FailureException(this.failure);

  final Failure failure;

  @override
  String toString() => 'FailureException(${failure.message})';
}

/// Converts any error surfaced by a stream or `catch` into a [Failure].
Failure toFailure(Object error) => switch (error) {
  FailureException(:final failure) => failure,
  _ => UnexpectedFailure(error.toString()),
};
