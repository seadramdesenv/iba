import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCheckScreen extends StatefulWidget {
  @override
  _AuthCheckScreenState createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _checkBiometricsAndTokens();
  }

  Future<void> _checkBiometricsAndTokens() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('auth_token');

    if (accessToken != null) {
      final isAuthenticated = await _authenticateDeviceCredentials();

      if (isAuthenticated) {
        Navigator.pushReplacementNamed(context, '/default');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      // Se não tiver token, vai para o login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<bool> _authenticateDeviceCredentials() async {
    try {
      final canCheckBiometrics = await auth.canCheckBiometrics;
      final isDeviceSupported = await auth.isDeviceSupported();

      if (!canCheckBiometrics && !isDeviceSupported) {
        print("Biometria ou senha não disponível no dispositivo.");
        return false;
      }

      return await auth.authenticate(
        localizedReason: 'Confirme sua identidade para continuar',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
    } catch (e) {
      print("Erro durante a autenticação: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/logo-letra.jpg',
              width: 300,
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}