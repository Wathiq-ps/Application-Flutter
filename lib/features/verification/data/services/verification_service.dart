import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../models/verification_model.dart';

class VerificationService {
  final Dio dio;

  VerificationService(this.dio);

  Future<VerificationModel> uploadIdAndSelfie({
    required XFile idImage,
    required XFile selfieImage,
    required String documentNumber,
  }) async {
    final formData = FormData.fromMap({
      'type': 'national_id',
      'document_number': documentNumber,

      'front_image': await MultipartFile.fromFile(
        idImage.path,
        filename: idImage.name,
      ),

      'selfie_image': await MultipartFile.fromFile(
        selfieImage.path,
        filename: selfieImage.name,
      ),
    });

    final response = await dio.post('/api/v1/kyc/documents', data: formData);

    return VerificationModel.fromJson(response.data['data'] ?? response.data);
  }

  Future<VerificationModel> getVerificationStatus() async {
    final response = await dio.get('/api/v1/kyc/status');

    return VerificationModel.fromJson(response.data['data'] ?? response.data);
  }
}
