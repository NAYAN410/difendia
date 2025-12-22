import 'package:defindia3/features/auth/data/repositories/master_auth_repository_impl.dart';

class VerifyMasterPassword {
  final MasterAuthRepository _repo;

  VerifyMasterPassword(this._repo);

  Future<bool> call(String plainPassword) {
    return _repo.verify(plainPassword);
  }
}
