import 'package:image_picker/image_picker.dart';
import 'package:image_picker2_plus/image_picker2.dart';

class ImagePickerService {
  Future<List<String>> pickImages({required int limit}) async {
    final images = await ImagePicker2.pickMedia(
      limit: limit,
      type: PickerMediaType.image,
      maxWidth: 1200,
      quality: 85,
    );

    return images ?? [];
  }

   Future<String?> takePhoto() async {
    final ImagePicker picker = ImagePicker();

    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1200,
      imageQuality: 85,
    );

    return photo?.path;
  }
}
