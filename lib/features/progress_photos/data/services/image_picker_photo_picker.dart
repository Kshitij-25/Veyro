import 'package:fitness_trakcer/features/progress_photos/domain/services/photo_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PhotoPicker)
class ImagePickerPhotoPicker implements PhotoPicker {
  ImagePickerPhotoPicker();

  final _picker = ImagePicker();

  @override
  Future<String?> pick(PhotoSource source) async {
    final file = await _picker.pickImage(
      source: source == PhotoSource.camera
          ? ImageSource.camera
          : ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 85,
    );
    return file?.path;
  }
}
