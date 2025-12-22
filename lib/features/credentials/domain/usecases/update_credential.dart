import 'package:defindia3/features/credentials/data/repositories/credential_repository_impl.dart';
import 'package:defindia3/features/credentials/domain/entities/credential_entity.dart';

class UpdateCredential {
  final CredentialRepository _repo;

  UpdateCredential(this._repo);

  Future<CredentialEntity> call({
    required CredentialEntity existing,
    String? siteName,
    String? siteUrl,
    String? username,
    String? password,
  }) {
    return _repo.update(
      existing: existing,
      siteName: siteName,
      siteUrl: siteUrl,
      username: username,
      password: password,
    );
  }
}
