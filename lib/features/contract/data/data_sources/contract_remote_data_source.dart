import 'package:dio/dio.dart';
import '../../../../core/constant/api_constants.dart';
import '../../../../core/error/api_exception.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../models/send_request_model.dart';

abstract class ContractRemoteDataSource {
  Future<void> sendPropertyRequest(SendRequestModel model);
}

class ContractRemoteDataSourceImpl implements ContractRemoteDataSource {
  final Dio dio;
  final SecureStorageService secureStorageService;

  ContractRemoteDataSourceImpl(
    this.dio, {
    this.secureStorageService = const SecureStorageService(),
  });

  @override
  Future<void> sendPropertyRequest(SendRequestModel model) async {
    try {
      final token = await secureStorageService.getAccessToken();
      final formData = model.toFormData();
      final endpoint = ApiConstants.sendPropertyRequestEndpoint(model.propertyId);

      await dio.post(
        endpoint,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            if (token != null && token.isNotEmpty)
              'Authorization': 'Bearer $token',
          },
        ),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
