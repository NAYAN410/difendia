import 'package:defindia3/features/credentials/data/repositories/credential_repository_impl.dart';
import 'package:defindia3/features/credentials/domain/entities/credential_entity.dart';

class DeleteCredential {
  final CredentialRepository _repo;

  DeleteCredential(this._repo);

  Future<void> call(CredentialEntity entity) {
    return _repo.delete(entity);
  }
}
