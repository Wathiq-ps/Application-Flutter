class CacheEntry {
  final Object? data;
  final DateTime savedAt;
  const CacheEntry({required this.data, required this.savedAt});
}

abstract class CacheStore {
  Future<CacheEntry?> read(String key);
  Future<void> write(String key, Object? json);
  Future<void> remove(String key);
  Future<void> clearAll();
}