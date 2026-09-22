import 'package:dio/dio.dart';
import '../../features/auth/data/data_sources/auth_data_source.dart';
import '../../features/auth/data/repository_implementations/auth_repository_impl.dart';
import '../../features/auth/domain/repository/auth_repository.dart';
import '../../features/property/data/data_sources/create_property_remote_data_source.dart';
import '../../features/property/data/repositories/create_property_repository_impl.dart';
import '../../features/property/domain/repository/create_property_repository.dart';
import '../../features/property/domain/usecases/create_property_usecase.dart';
import '../constant/api_constants.dart';
import '../services/secure_storage_service.dart';

class Injector {
  Injector._();

  static final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  static const SecureStorageService secureStorage = SecureStorageService();

  static final AuthRepository authRepository = AuthRepositoryImpl(
    AuthDataSourceImpl(_dio),
    secureStorage,
  );

  static final CreatePropertyRemoteDataSource createPropertyRemoteDataSource =
      CreatePropertyRemoteDataSourceImpl(
    _dio,
    secureStorageService: secureStorage,
  );

  static final CreatePropertyRepository createPropertyRepository =
      CreatePropertyRepositoryImpl(createPropertyRemoteDataSource);

  static final CreatePropertyUseCase createPropertyUseCase =
      CreatePropertyUseCase(createPropertyRepository);
}