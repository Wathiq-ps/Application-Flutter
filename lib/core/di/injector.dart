import 'package:dio/dio.dart';
import '../../features/auth/data/data_sources/auth_data_source.dart';
import '../../features/auth/data/repository_implementations/auth_repository_impl.dart';
import '../../features/auth/domain/repository/auth_repository.dart';
import '../../features/home/data/data_sources/home_data_source.dart';
import '../../features/home/data/repository_implementations/home_repository_impl.dart';
import '../../features/home/domain/repository/home_repository.dart';
import '../../features/owner_property_mangment/data/data_sources/owner_property_remote_data_source.dart';
import '../../features/owner_property_mangment/data/repositories_impl/owner_property_repository_impl.dart';
import '../../features/owner_property_mangment/domain/repositories/owner_property_repository.dart';
import '../../features/profile/data/data_sources/edit_profile_remote_data_source.dart';
import '../../features/profile/data/data_sources/profile_remote_data_source.dart';
import '../../features/profile/data/repository_implementations/edit_profile_repository_impl.dart';
import '../../features/profile/data/repository_implementations/profile_repository_impl.dart';
import '../../features/profile/domain/repository/edit_profile_repository.dart';
import '../../features/profile/domain/repository/profile_repository.dart';
import '../../features/saved/data/data_sources/favorites_local_data_source.dart';
import '../../features/saved/data/repository_implementations/favorites_repository_impl.dart';
import '../../features/saved/domain/repositories/favorites_repository.dart';
import '../../features/search/domain/data/data_sources/search_data_source.dart';
import '../../features/search/domain/data/repository_implementations/search_repository_impl.dart';
import '../../features/search/domain/repository/search_repository.dart';
import '../../features/verification/data/repositories/verification_repository_impl.dart';
import '../../features/verification/data/services/verification_service.dart';
import '../../features/verification/domain/repositories/verify_repositories.dart';
import '../cache/cache_store.dart';
import '../cache/cached_fetcher.dart';
import '../cache/shared_prefs_cache_store.dart';
import '../../features/property/data/data_sources/create_property_remote_data_source.dart';
import '../../features/property/data/repositories/create_property_repository_impl.dart';
import '../../features/property/domain/repository/create_property_repository.dart';
import '../../features/property/domain/usecases/create_property_usecase.dart';
import '../constant/api_constants.dart';
import '../services/image_picker_service.dart';
import '../services/secure_storage_service.dart';

class Injector {
  Injector._();

  // ── Core ──────────────────────────────────────────────
  static final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
  static const SecureStorageService secureStorage = SecureStorageService();
  static const FavoritesLocalDataSource _favoritesLocalDataSource =
  FavoritesLocalDataSource();
  static final FavoritesRepository favoritesRepository =
  FavoritesRepositoryImpl(_favoritesLocalDataSource);

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

  // ── Create property ───────────────────────────────────
  static final CreatePropertyRemoteDataSource createPropertyRemoteDataSource =
  CreatePropertyRemoteDataSourceImpl(
    _dio,
    secureStorageService: secureStorage,
  );

  static final CreatePropertyRepository createPropertyRepository =
  CreatePropertyRepositoryImpl(createPropertyRemoteDataSource);

  static final CreatePropertyUseCase createPropertyUseCase =
  CreatePropertyUseCase(createPropertyRepository);

  // ── Owner properties ──────────────────────────────────
  static final OwnerPropertyRepository ownerPropertyRepository =
  OwnerPropertyRepositoryImpl(
    OwnerPropertyRemoteDataSourceImpl(_dio, secureStorage),
    cachedFetcher,
  );

  // ── Search ────────────────────────────────────────────
  static final SearchRepository searchRepository = SearchRepositoryImpl(
    SearchDataSourceImpl(_dio),
    cachedFetcher,
  );

  // ── Profile ───────────────────────────────────────────
  static final ProfileRepository profileRepository = ProfileRepositoryImpl(
    ProfileRemoteDataSourceImpl(_dio, secureStorage),
  );

  // ── Verification ──────────────────────────────────────
  static final Dio _authDio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl))
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await secureStorage.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  static final EditProfileRepository editProfileRepository = EditProfileRepositoryImpl(
    EditProfileRemoteDataSourceImpl(_dio, secureStorage),
  );

  static final VerificationRepository verificationRepository =
  VerificationRepositoryImpl(VerificationService(_authDio));

  static final ImagePickerService imagePickerService = ImagePickerService();
}