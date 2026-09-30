import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import '../../../../core/constant/api_constants.dart';
import '../../../../core/error/api_exception.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../domain/entities/edit_profile_user_entity.dart';
import '../../domain/repository/edit_profile_repository.dart';
import '../error/profile_validation_exception.dart';
import '../models/edit_profile_user_model.dart';

abstract class EditProfileRemoteDataSource {
  Future<Map<String, dynamic>> getProfileRaw();
  Future<Map<String, dynamic>> updateProfileRaw(Map<String, dynamic> fields, SignatureInput? signature);
}

class EditProfileRemoteDataSourceImpl implements EditProfileRemoteDataSource {
  const EditProfileRemoteDataSourceImpl(this._dio, this._secureStorage);

  final Dio _dio;
  final SecureStorageService _secureStorage;

  Future<Options> _authOptions() async {
    final token = await _secureStorage.getAccessToken();
    return Options(headers: {if (token != null) 'Authorization': 'Bearer $token'});
  }

  @override
  Future<Map<String, dynamic>> getProfileRaw() async {
    try {
      final response = await _dio.get(ApiConstants.profileEndpoint, options: await _authOptions());
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<Map<String, dynamic>> updateProfileRaw(
      Map<String, dynamic> fields,
      SignatureInput? signature,
      ) async {
    try {
      final form = FormData();
      fields.forEach((key, value) => form.fields.add(MapEntry(key, value.toString())));

      if (signature != null) {
        form.files.add(MapEntry('signature_image', await _signaturePart(signature)));
      }

      final response = await _dio.post(
        ApiConstants.profileEndpoint,
        data: form,
        options: await _authOptions(),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      final data = e.response?.data;
      if (e.response?.statusCode == 422 && data is Map) {
        final rawErrors = data['errors'];
        final fieldErrors = <String, List<String>>{
          if (rawErrors is Map)
            for (final entry in rawErrors.entries)
              entry.key.toString(): (entry.value as List).map((v) => v.toString()).toList(),
        };
        throw ProfileValidationException(
          data['message']?.toString() ?? 'Validation failed.',
          fieldErrors,
        );
      }
      throw ApiException.fromDioException(e);
    }
  }

  Future<MultipartFile> _signaturePart(SignatureInput signature) async {
    if (signature.bytes != null) {
      return MultipartFile.fromBytes(
        signature.bytes!,
        filename: 'signature.png',
        contentType: MediaType('image', 'png'),
      );
    }
    final path = signature.filePath!;
    final ext = path.split('.').last.toLowerCase();
    return MultipartFile.fromFile(
      path,
      filename: 'signature.$ext',
      contentType: MediaType('image', ext == 'jpg' ? 'jpeg' : ext),
    );
  }
}