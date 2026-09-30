import 'package:mobile/core/cache/data_result.dart';
import '../entities/search_result_entity.dart';

abstract class SearchRepository {
  Stream<DataResult<SearchResultEntity>> watchSearch({
    String query = '',
    String? listingType,
  });

  Future<SearchResultEntity> fetchPage({
    String query = '',
    String? listingType,
    required int page,
  });
}