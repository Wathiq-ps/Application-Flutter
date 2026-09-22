import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constant/storage_keys.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  const SecureStorageService([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: StorageKeys.accessToken, value: accessToken);
    await _storage.write(key: StorageKeys.refreshToken, value: refreshToken);
  }

  Future<String?> getAccessToken() async {
    final token = await _storage.read(key: StorageKeys.accessToken);
    // إذا لم يكن هناك توكن وموجودين في وضع التطوير، استخدم التوكن التجريبي
    if (kDebugMode && (token == null || token.isEmpty)) {
      return 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3dhdGhpcS1iYWNrLnVwLnJhaWx3YXkuYXBwIiwic3ViIjoiM2Q5YmU1ODItMjkyZC00YzRjLWE1ZWYtNGUyNDlkZDY0OTQ1IiwiaWF0IjoxNzg5NjUxMTYyLCJleHAiOjkxNzg5NjUxMTYyfQ.F1UUKhNKu8u4hOvV2JqTjtMrCC2cM-yMlbMVXPDcXd4';
    }
    return token;
  }

  Future<String?> getRefreshToken() =>
      _storage.read(key: StorageKeys.refreshToken);

  Future<void> clearTokens() async {
    await _storage.delete(key: StorageKeys.accessToken);
    await _storage.delete(key: StorageKeys.refreshToken);
  }

  Future<bool> hasValidSession() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
