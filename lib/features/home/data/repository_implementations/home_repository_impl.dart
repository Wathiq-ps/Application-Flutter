import 'package:mobile/core/cache/cached_fetcher.dart';
import 'package:mobile/core/cache/data_result.dart';
import '../../../../core/constant/cache_keys.dart';
import '../../domain/entities/home_data_entity.dart';
import '../../domain/repository/home_repository.dart';
import '../data_sources/home_data_source.dart';
import '../models/home_data_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._dataSource, this._cache);

  final HomeDataSource _dataSource;
  final CachedFetcher _cache;

  @override
  Stream<DataResult<HomeDataEntity>> watchHome() => _cache.load<HomeDataEntity>(
    key: CacheKeys.home,
    fetchRaw: _dataSource.getHomeJson,
    parse: (raw) => HomeDataModel.fromJson(raw as Map<String, dynamic>),
  );
}