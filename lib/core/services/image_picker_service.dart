import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker2_plus/image_picker2.dart';

class ImagePickerService {
  Future<List<String>> pickImages({required int limit}) async {
    if (kIsWeb) {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage(
        maxWidth: 1200,
        imageQuality: 85,
      );
      return images.map((e) => e.path).toList();
    } else {
      final images = await ImagePicker2.pickMedia(
        limit: limit,
        type: PickerMediaType.image,
        maxWidth: 1200,
        quality: 85,
      );

      return images ?? [];
    }
  }

  /// Opens the camera. Pass [useFrontCamera] for selfies.
  Future<String?> takePhoto({bool useFrontCamera = false}) async {
    final ImagePicker picker = ImagePicker();

    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice:
      useFrontCamera ? CameraDevice.front : CameraDevice.rear,
      maxWidth: 1200,
      imageQuality: 85,
    );

    return photo?.path;
  }
}