import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class FavoritesLocalDataSource {
  const FavoritesLocalDataSource();

  static const _storageKey = 'favorites_v1';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<Map<String, dynamic>> readAll() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_storageKey);
    if (raw == null) return {'order': <String>[], 'items': <String, dynamic>{}};

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return {
        'order': List<String>.from(decoded['order'] as List? ?? const []),
        'items': Map<String, dynamic>.from(decoded['items'] as Map? ?? const {}),
      };
    } catch (_) {
      await prefs.remove(_storageKey); 
      return {'order': <String>[], 'items': <String, dynamic>{}};
    }
  }

  Future<void> writeAll({
    required List<String> order,
    required Map<String, dynamic> items,
  }) async {
    final prefs = await _prefs;
    await prefs.setString(_storageKey, jsonEncode({'order': order, 'items': items}));
  }

  Future<void> clear() async => (await _prefs).remove(_storageKey);
}