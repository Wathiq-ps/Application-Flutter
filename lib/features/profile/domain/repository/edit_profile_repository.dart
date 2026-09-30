import 'dart:typed_data';
import '../entities/edit_profile_user_entity.dart';


class SignatureInput {
  const SignatureInput.file(String path)
      : filePath = path,
        bytes = null;

  const SignatureInput.bytes(Uint8List data)
      : bytes = data,
        filePath = null;

  final String? filePath;
  final Uint8List? bytes;
}

abstract class EditProfileRepository {
  Future<EditProfileUserEntity> getProfile();

  Future<EditProfileUserEntity> updateProfile({
    required String name,
    required String nationality,
    required ProfileDocumentType documentType,
    required String documentNumber,
    SignatureInput? signature,
  });
}