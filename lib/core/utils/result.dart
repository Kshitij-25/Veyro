import 'package:fitness_trakcer/core/error/failure_exception.dart';
import 'package:fitness_trakcer/core/error/failures.dart';

/// Either a successful value or a [Failure]. Returned by every use case and
/// repository method that performs a one-shot operation.
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Fail<T>;

  T? get dataOrNull => switch (this) {
    Success<T>(:final data) => data,
    Fail<T>() => null,
  };

  Failure? get failureOrNull => switch (this) {
    Success<T>() => null,
    Fail<T>(:final failure) => failure,
  };

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) => switch (this) {
    Success<T>(:final data) => success(data),
    Fail<T>(failure: final f) => failure(f),
  };

  /// Transforms the success value, leaving failures untouched.
  Result<R> map<R>(R Function(T data) transform) => switch (this) {
    Success<T>(:final data) => Success(transform(data)),
    Fail<T>(:final failure) => Fail(failure),
  };

  /// Returns the data or throws a [FailureException].
  T getOrThrow() => switch (this) {
    Success<T>(:final data) => data,
    Fail<T>(:final failure) => throw FailureException(failure),
  };
}

final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;
}

final class Fail<T> extends Result<T> {
  const Fail(this.failure);

  final Failure failure;
}

/// Runs [action] and converts any thrown error into a [Fail].
Future<Result<T>> guard<T>(Future<T> Function() action) async {
  try {
    return Success(await action());
  } on FailureException catch (e) {
    return Fail(e.failure);
  } on UnsupportedError catch (e) {
    return Fail(UnsupportedPlatformFailure(e.message ?? 'Unsupported.'));
  } catch (e) {
    return Fail(UnexpectedFailure(e.toString()));
  }
}
