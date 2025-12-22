import 'package:hive_flutter/hive_flutter.dart';
import 'package:defindia3/features/credentials/data/models/credential_model.dart';

class HiveDbService {
  HiveDbService._();

  static const String credentialBoxName = 'credential_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter<CredentialModel>(CredentialModelAdapter());
    await Hive.openBox<CredentialModel>(credentialBoxName);
  }

  static Box<CredentialModel> get credentialBox =>
      Hive.box<CredentialModel>(credentialBoxName);
}
