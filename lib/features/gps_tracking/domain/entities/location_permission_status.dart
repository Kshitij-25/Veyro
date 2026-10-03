enum LocationPermissionStatus {
  granted,
  denied,
  deniedForever,
  serviceDisabled;

  bool get isGranted => this == LocationPermissionStatus.granted;
}
