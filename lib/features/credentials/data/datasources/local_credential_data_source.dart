import 'package:uuid/uuid.dart';
import 'package:defindia3/services/hive_db_service.dart';
import 'package:defindia3/services/secure_storage_service.dart';
import 'package:defindia3/features/credentials/data/models/credential_model.dart';
import 'package:defindia3/features/credentials/domain/entities/credential_entity.dart';

class LocalCredentialDataSource {
  final _uuid = const Uuid();

  Future<List<CredentialEntity>> getAll() async {
    final box = HiveDbService.credentialBox;
    return box.values.map((e) => e.toEntity()).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Future<CredentialEntity> add({
    required String siteName,
    String? siteUrl,
    required String username,
    required String password,
  }) async {
    final id = _uuid.v4();
    final secureId = _uuid.v4();
    final now = DateTime.now();

    await SecureStorageService.saveCredentials(
      secureId: secureId,
      username: username,
      password: password,
    );

    final model = CredentialModel(
      id: id,
      siteName: siteName,
      siteUrl: siteUrl,
      secureId: secureId,
      createdAt: now,
      updatedAt: now,
    );

    final box = HiveDbService.credentialBox;
    await box.put(id, model);

    return model.toEntity();
  }

  Future<CredentialEntity> update({
    required CredentialEntity existing,
    String? siteName,
    String? siteUrl,
    String? username,
    String? password,
  }) async {
    final box = HiveDbService.credentialBox;
    final stored = box.get(existing.id);
    if (stored == null) {
      throw Exception('Credential not found');
    }

    final updated = CredentialModel(
      id: stored.id,
      siteName: siteName ?? stored.siteName,
      siteUrl: siteUrl ?? stored.siteUrl,
      secureId: stored.secureId,
      createdAt: stored.createdAt,
      updatedAt: DateTime.now(),
    );

    if (username != null || password != null) {
      final (oldU, oldP) =
      await SecureStorageService.readCredentials(stored.secureId);
      await SecureStorageService.saveCredentials(
        secureId: stored.secureId,
        username: username ?? (oldU ?? ''),
        password: password ?? (oldP ?? ''),
      );
    }

    await box.put(stored.id, updated);
    return updated.toEntity();
  }

  Future<void> delete(CredentialEntity entity) async {
    final box = HiveDbService.credentialBox;
    await box.delete(entity.id);
    await SecureStorageService.deleteCredentials(entity.secureId);
  }
}
