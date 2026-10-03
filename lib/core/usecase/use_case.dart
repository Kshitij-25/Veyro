import 'package:fitness_trakcer/core/utils/result.dart';

/// A single application operation. Use cases are the only entry points the
/// presentation layer uses to reach the domain.
abstract interface class UseCase<Output, Params> {
  Future<Result<Output>> call(Params params);
}

/// A use case exposing a continuously updating value.
abstract interface class StreamUseCase<Output, Params> {
  Stream<Output> call(Params params);
}

final class NoParams {
  const NoParams();
}
