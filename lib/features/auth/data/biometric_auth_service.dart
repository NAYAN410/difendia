import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  BiometricAuthService._();

  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> authenticate() async {
    try {
      final canBiometric = await _auth.canCheckBiometrics;
      final isSupported = await _auth.isDeviceSupported();
      print('local_auth => canBiometric=$canBiometric, isSupported=$isSupported');

      if (!canBiometric && !isSupported) {
        print('local_auth => no biometric / device auth support');
        return false;
      }

      final didAuthenticate = await _auth.authenticate(
        localizedReason: 'Authenticate to open this login',
        options: const AuthenticationOptions(
          biometricOnly: false,
          useErrorDialogs: true,
          stickyAuth: true,
          sensitiveTransaction: true,
        ),
      );

      print('local_auth => didAuthenticate=$didAuthenticate');
      return didAuthenticate;
    } catch (e) {
      print('local_auth => error: $e');
      return false;
    }
  }

}
