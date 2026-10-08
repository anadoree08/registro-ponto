import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> autenticar() async {
    try {
      final bool dispositivoSuporta = await auth.isDeviceSupported();

      if (!dispositivoSuporta) {
        return false;
      }

      return await auth.authenticate(
        localizedReason: 'Use sua biometria para entrar no aplicativo.',
        biometricOnly: true,
      );
    } catch (e) {
      return false;
    }
  }
}
