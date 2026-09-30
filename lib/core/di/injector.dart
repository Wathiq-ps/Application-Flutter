import 'package:dio/dio.dart';
import '../../features/auth/data/data_sources/auth_data_source.dart';
import '../../features/auth/data/repository_implementations/auth_repository_impl.dart';
import '../../features/auth/domain/repository/auth_repository.dart';
import '../../features/home/data/data_sources/home_data_source.dart';
import '../../features/home/data/repository_implementations/home_repository_impl.dart';
import '../../features/home/domain/repository/home_repository.dart';
import '../cache/cache_store.dart';
import '../cache/cached_fetcher.dart';
import '../cache/shared_prefs_cache_store.dart';
import '../../features/property/data/data_sources/create_property_remote_data_source.dart';
import '../../features/property/data/repositories/create_property_repository_impl.dart';
import '../../features/property/domain/repository/create_property_repository.dart';
import '../../features/property/domain/usecases/create_property_usecase.dart';
import '../../features/contract/data/data_sources/contract_remote_data_source.dart';
import '../../features/contract/data/repositories/contract_repository_impl.dart';
import '../../features/contract/domain/repository/contract_repository.dart';
import '../../features/contract/domain/usecases/contract_usecase.dart';
import '../constant/api_constants.dart';
import '../services/secure_storage_service.dart';

class Injector {
  Injector._();

  // ── Core ──────────────────────────────────────────────
  static final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
  static const SecureStorageService secureStorage = SecureStorageService();

  // ── Cache ─────────────────────────────────────────────
  static const CacheStore cacheStore = SharedPrefsCacheStore();
  static const CachedFetcher cachedFetcher = CachedFetcher(cacheStore);

  // ── Auth ──────────────────────────────────────────────
  static final AuthRepository authRepository = AuthRepositoryImpl(
    AuthDataSourceImpl(_dio),
    secureStorage,
  );

  // ── Home ──────────────────────────────────────────────
  static final HomeRepository homeRepository = HomeRepositoryImpl(
    HomeDataSourceImpl(_dio),
    cachedFetcher,
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

  // ── Contract / Request ────────────────────────────────
  static final ContractRemoteDataSource contractRemoteDataSource =
      ContractRemoteDataSourceImpl(
    _dio,
    secureStorageService: secureStorage,
  );

  static final ContractRepository contractRepository =
      ContractRepositoryImpl(contractRemoteDataSource);

  static final SendPropertyRequestUseCase sendPropertyRequestUseCase =
      SendPropertyRequestUseCase(contractRepository);
}
