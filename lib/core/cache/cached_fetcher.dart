import 'cache_store.dart';
import 'data_result.dart';

class CachedFetcher {
  const CachedFetcher(this._store);
  final CacheStore _store;

  Stream<DataResult<T>> load<T>({
    required String key,
    required Future<Object?> Function() fetchRaw,
    required T Function(Object? raw) parse,
  }) async* {
    T? cached;
    DateTime? cachedAt;

    final entry = await _store.read(key);
    if (entry != null) {
      try {
        cached = parse(entry.data);
        cachedAt = entry.savedAt;
      } catch (_) {
        await _store.remove(key);
        cached = null;
      }
    }
    if (cached != null) {
      yield DataResult<T>(data: cached, isFromCache: true, updatedAt: cachedAt);
    }

    T fresh;
    try {
      final raw = await fetchRaw();
      fresh = parse(raw);
      try {
        await _store.write(key, raw);
      } catch (_) {/* a failed cache write must never fail the screen */}
    } catch (e) {
      if (cached == null) rethrow;
      yield DataResult<T>(
        data: cached,
        isFromCache: true,
        updatedAt: cachedAt,
        refreshError: e,
      );
      return;
    }

    yield DataResult<T>(data: fresh, isFromCache: false, updatedAt: DateTime.now());
  }
}