import 'package:equatable/equatable.dart';

/// Domain-level description of something that went wrong.
///
/// Repositories translate exceptions into a [Failure] so that the domain and
/// presentation layers never depend on data-layer exception types.
sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class DatabaseFailure extends Failure {
  const DatabaseFailure([super.message = 'A storage error occurred.']);
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'The requested item was not found.']);
}

final class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'Permission was denied.']);
}

final class UnsupportedPlatformFailure extends Failure {
  const UnsupportedPlatformFailure([
    super.message = 'This feature is not supported on this platform.',
  ]);
}

final class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'Could not reach the server. Check your connection.',
  ]);
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'Something went wrong.']);
}
