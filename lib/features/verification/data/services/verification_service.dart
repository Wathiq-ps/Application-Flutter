import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constant/api_constants.dart';
import '../../../../core/error/verification_exception.dart';
import '../models/verification_model.dart';

class VerificationService {
  final Dio dio;

  VerificationService(this.dio);

  /// POST /api/v1/kyc/documents  (multipart: front_image + selfie_image)
  Future<VerificationModel> uploadIdAndSelfie({
    required XFile idImage,
    required XFile selfieImage,
  }) async {
    try {
      final formData = FormData.fromMap({
        'front_image': await _toMultipart(idImage, 'front_image.jpg'),
        'selfie_image': await _toMultipart(selfieImage, 'selfie_image.jpg'),
      });

      final response = await dio.post(
        ApiConstants.kycDocumentsEndpoint,
        data: formData,
      );

      return _parse(response.data);
    } on DioException catch (e) {
      throw VerificationException.fromDioException(e);
    }
  }

  Future<VerificationModel> getVerificationStatus() async {
    try {
      final response = await dio.get(ApiConstants.kycStatusEndpoint);
      return _parse(response.data);
    } on DioException catch (e) {
      throw VerificationException.fromDioException(e);
    }
  }

  Future<MultipartFile> _toMultipart(XFile file, String fallbackName) async {
    final bytes = await file.readAsBytes();
    var name = file.name.isNotEmpty ? file.name : fallbackName;
    // Web blobs can come without an extension; the backend needs one.
    if (!name.contains('.')) name = '$name.jpg';
    return MultipartFile.fromBytes(bytes, filename: name);
  }

  VerificationModel _parse(dynamic body) {
    if (body is Map) {
      final inner = body['data'];
      final json = inner is Map ? inner : body;
      return VerificationModel.fromJson(Map<String, dynamic>.from(json));
    }
    return const VerificationModel();
  }
}