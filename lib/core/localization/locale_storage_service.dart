import 'package:shared_preferences/shared_preferences.dart';
import '../constant/storage_keys.dart';
import 'app_locale.dart';

class LocaleStorageService {
  const LocaleStorageService();

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();


  Future<AppLocale?> read() async {
    final prefs = await _prefs;
    final code = prefs.getString(StorageKeys.localeCode);
    return code == null ? null : AppLocale.fromCode(code);
  }

  Future<void> save(AppLocale locale) async {
    final prefs = await _prefs;
    await prefs.setString(StorageKeys.localeCode, locale.code);
  }
}