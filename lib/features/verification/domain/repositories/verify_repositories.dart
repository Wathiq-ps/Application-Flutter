import 'package:image_picker/image_picker.dart';

import '../../data/models/verification_model.dart';

abstract class VerificationRepository {
  Future<VerificationModel> uploadIdAndSelfie({
    required XFile idImage,
    required XFile selfieImage,
    required String documentNumber,
  });

  Future<VerificationModel> getVerificationStatus();
}
