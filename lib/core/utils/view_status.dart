/// Lifecycle of an asynchronous operation as seen by a Cubit/screen.
enum ViewStatus {
  initial,
  loading,
  success,
  failure;

  bool get isLoading => this == ViewStatus.loading;

  /// Nothing has been loaded yet (not started, or still loading).
  bool get isPending =>
      this == ViewStatus.initial || this == ViewStatus.loading;
  bool get isFailure => this == ViewStatus.failure;
  bool get isSuccess => this == ViewStatus.success;
}
