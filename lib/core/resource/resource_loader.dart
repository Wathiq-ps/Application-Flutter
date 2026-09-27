import 'package:mobile/core/cache/data_result.dart';
import 'package:mobile/core/error/api_exception.dart';
import '../constant/strings.dart';
import 'resource_state.dart';

class ResourceLoader<T> {
  ResourceLoader(this._source, {this.mapError = defaultMapError});

  final Stream<DataResult<T>> Function() _source;
  final String Function(Object error) mapError;

  static String defaultMapError(Object e) =>
      e is ApiException ? e.message : AppStrings.somethingWentWrong;

  Stream<ResourceState<T>> load(ResourceState<T> current) async* {
    var s = current.copyWith(
      isRefreshing: true,
      status: current.hasData ? ResourceStatus.success : ResourceStatus.loading,
    );
    yield s;

    try {
      await for (final r in _source()) {
        if (r.isFromCache && r.refreshError == null && current.hasData) continue;

        s = s.copyWith(
          status: ResourceStatus.success,
          data: r.data,
          isFromCache: r.isFromCache,
          updatedAt: r.updatedAt,
          errorMessage: r.refreshError == null ? null : mapError(r.refreshError!),
          clearError: r.refreshError == null && !r.isFromCache, // fresh data clears the banner
        );
        yield s;
      }
    } catch (e) {
      // Only reached when there is NO cache.
      s = s.copyWith(status: ResourceStatus.failure, errorMessage: mapError(e));
      yield s;
    }

    yield s.copyWith(isRefreshing: false);
  }
}