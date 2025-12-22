import 'package:defindia3/features/credentials/data/repositories/credential_repository_impl.dart';
import 'package:defindia3/features/credentials/domain/entities/credential_entity.dart';

class GetAllCredentials {
  final CredentialRepository _repo;

  GetAllCredentials(this._repo);

  Future<List<CredentialEntity>> call() {
    return _repo.getAll();
  }
}
