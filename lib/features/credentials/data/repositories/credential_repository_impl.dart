import 'package:defindia3/features/credentials/domain/entities/credential_entity.dart';
import 'package:defindia3/features/credentials/data/datasources/local_credential_data_source.dart';

class CredentialRepository {
  final LocalCredentialDataSource _local;

  CredentialRepository(this._local);

  Future<List<CredentialEntity>> getAll() => _local.getAll();

  Future<CredentialEntity> add({
    required String siteName,
    String? siteUrl,
    required String username,
    required String password,
  }) {
    return _local.add(
      siteName: siteName,
      siteUrl: siteUrl,
      username: username,
      password: password,
    );
  }

  Future<CredentialEntity> update({
    required CredentialEntity existing,
    String? siteName,
    String? siteUrl,
    String? username,
    String? password,
  }) {
    return _local.update(
      existing: existing,
      siteName: siteName,
      siteUrl: siteUrl,
      username: username,
      password: password,
    );
  }

  Future<void> delete(CredentialEntity entity) => _local.delete(entity);
}
