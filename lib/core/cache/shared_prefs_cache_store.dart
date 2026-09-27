import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'cache_store.dart';

class SharedPrefsCacheStore implements CacheStore {
  const SharedPrefsCacheStore();

  static const _prefix = 'cache_v1:';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  @override
  Future<CacheEntry?> read(String key) async {
    final prefs = await _prefs;
    final raw = prefs.getString('$_prefix$key');
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return CacheEntry(
        data: map['data'],
        savedAt: DateTime.fromMillisecondsSinceEpoch(map['savedAt'] as int),
      );
    } catch (_) {
      await prefs.remove('$_prefix$key');
      return null;
    }
  }

  @override
  Future<void> write(String key, Object? json) async {
    final prefs = await _prefs;
    await prefs.setString(
      '$_prefix$key',
      jsonEncode({'savedAt': DateTime.now().millisecondsSinceEpoch, 'data': json}),
    );
  }

  @override
  Future<void> remove(String key) async =>
      (await _prefs).remove('$_prefix$key');

  @override
  Future<void> clearAll() async {
    final prefs = await _prefs;
    for (final k in prefs.getKeys().where((k) => k.startsWith(_prefix))) {
      await prefs.remove(k);
    }
  }
}