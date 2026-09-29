import 'package:mobile/core/cache/cached_fetcher.dart';
import 'package:mobile/core/cache/data_result.dart';
import '../../../../../core/constant/cache_keys.dart';
import '../../entities/search_result_entity.dart';
import '../../repository/search_repository.dart';
import '../data_sources/search_data_source.dart';
import '../models/search_result_model.dart';

class SearchRepositoryImpl implements SearchRepository {
  const SearchRepositoryImpl(this._dataSource, this._cache);

  final SearchDataSource _dataSource;
  final CachedFetcher _cache;

  static SearchResultEntity _parse(Object? raw) =>
      SearchResultModel.fromJson(raw as Map<String, dynamic>);

  @override
  Stream<DataResult<SearchResultEntity>> watchSearch({
    String query = '',
    String? listingType,
  }) {
    final q = query.trim();

    if (q.isEmpty) {
      return _cache.load<SearchResultEntity>(
        key: CacheKeys.search(listingType),
        fetchRaw: () => _dataSource.searchJson(listingType: listingType, page: 1),
        parse: _parse,
      );
    }

    return _fetchOnce(q, listingType);
  }

  Stream<DataResult<SearchResultEntity>> _fetchOnce(
      String query,
      String? listingType,
      ) async* {
    final raw = await _dataSource.searchJson(
      query: query,
      listingType: listingType,
      page: 1,
    );
    yield DataResult<SearchResultEntity>(
      data: _parse(raw),
      isFromCache: false,
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<SearchResultEntity> fetchPage({
    String query = '',
    String? listingType,
    required int page,
  }) async {
    final raw = await _dataSource.searchJson(
      query: query.trim(),
      listingType: listingType,
      page: page,
    );
    return _parse(raw);
  }
}