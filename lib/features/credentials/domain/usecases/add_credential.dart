import 'package:defindia3/features/credentials/data/repositories/credential_repository_impl.dart';
import 'package:defindia3/features/credentials/domain/entities/credential_entity.dart';

class AddCredential {
  final CredentialRepository _repo;

  AddCredential(this._repo);

  Future<CredentialEntity> call({
    required String siteName,
    String? siteUrl,
    required String username,
    required String password,
  }) {
    return _repo.add(
      siteName: siteName,
      siteUrl: siteUrl,
      username: username,
      password: password,
    );
  }
}
