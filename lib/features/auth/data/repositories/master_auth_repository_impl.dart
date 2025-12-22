import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:defindia3/features/auth/domain/entities/master_credential.dart';

class MasterAuthRepository {
  static const _key = 'master_password_hash';
  final FlutterSecureStorage _storage;

  MasterAuthRepository({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<MasterCredential?> getMaster() async {
    final hash = await _storage.read(key: _key);
    if (hash == null) return null;
    return MasterCredential(passwordHash: hash);
  }

  Future<void> setMaster(String plain) async {
    final hash = _hash(plain);
    await _storage.write(key: _key, value: hash);
  }

  Future<bool> verify(String plain) async {
    final stored = await _storage.read(key: _key);
    if (stored == null) return false;
    return stored == _hash(plain);
  }

  String _hash(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
