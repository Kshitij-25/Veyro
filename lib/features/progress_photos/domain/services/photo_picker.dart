enum PhotoSource { camera, gallery }

abstract interface class PhotoPicker {
  /// Path of a temporary copy of the chosen photo, or `null` if cancelled.
  Future<String?> pick(PhotoSource source);
}
