import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService._();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveCredentials({
    required String secureId,
    required String username,
    required String password,
  }) async {
    await _storage.write(key: '${secureId}_u', value: username);
    await _storage.write(key: '${secureId}_p', value: password);
  }

  static Future<(String?, String?)> readCredentials(String secureId) async {
    final u = await _storage.read(key: '${secureId}_u');
    final p = await _storage.read(key: '${secureId}_p');
    return (u, p);
  }

  static Future<void> deleteCredentials(String secureId) async {
    await _storage.delete(key: '${secureId}_u');
    await _storage.delete(key: '${secureId}_p');
  }
}
