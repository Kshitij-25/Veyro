enum HealthAccessStatus {
  /// Health Connect / HealthKit cannot be used on this device or platform.
  unavailable,
  notGranted,
  granted,

  /// iOS never reveals whether read access was granted; treat as "try it".
  unknown,
}
