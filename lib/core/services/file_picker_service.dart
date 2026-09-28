import 'package:file_picker/file_picker.dart';

class FilePickerService {
  Future<List<PlatformFile>> pickDocuments() async {
    final List<PlatformFile> files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );

    return files;
  }
}
