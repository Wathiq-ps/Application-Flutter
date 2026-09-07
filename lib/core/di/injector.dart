import 'package:dio/dio.dart';
import '../../features/auth/data/data_sources/auth_data_source.dart';
import '../../features/auth/data/repository_implementations/auth_repository_impl.dart';
import '../../features/auth/domain/repository/auth_repository.dart';
import '../constant/api_constants.dart';

class Injector {
  Injector._();

  static final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  static final AuthRepository authRepository =
  AuthRepositoryImpl(AuthDataSourceImpl(_dio));
}