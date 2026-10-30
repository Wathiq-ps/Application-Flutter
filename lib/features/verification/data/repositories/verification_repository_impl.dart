import 'package:image_picker/image_picker.dart';

import '../../domain/repositories/verify_repositories.dart';
import '../models/verification_model.dart';
import '../services/verification_service.dart';

class VerificationRepositoryImpl implements VerificationRepository {
  final VerificationService service;

  VerificationRepositoryImpl(this.service);

  @override
  Future<VerificationModel> uploadIdAndSelfie({
    required XFile idImage,
    required XFile selfieImage,
  }) {
    return service.uploadIdAndSelfie(
      idImage: idImage,
      selfieImage: selfieImage,
    );
  }

  @override
  Future<VerificationModel> getVerificationStatus() {
    return service.getVerificationStatus();
  }
}