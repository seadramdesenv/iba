import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    final hasToken = prefs.getString('auth_token') != null;

    if (hasToken) {
      // Se tem token, tenta autenticar com biometria
      final isAuthenticated = await _authenticateWithBiometrics();
      if (isAuthenticated) {
        Navigator.pushReplacementNamed(context, '/default');
      } else {
        // Se a biometria falhar ou for cancelada, vai para o login
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      // Se não tiver token, vai direto para o login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<bool> _authenticateWithBiometrics() async {
    try {
      final canCheckBiometrics = await auth.canCheckBiometrics;
      if (!canCheckBiometrics) {
        print("Biometria não disponível no dispositivo.");
        return false;
      }

      return await auth.authenticate(
        localizedReason: 'Use sua digital para fazer login',
        options: const AuthenticationOptions(
          // Força o uso apenas da biometria (digital ou facial)
          biometricOnly: true,
          // Mantém o diálogo de autenticação ativo
          stickyAuth: true,
          // Usa os diálogos de erro do sistema
          useErrorDialogs: true,
        ),
      );
    } on PlatformException catch (e) {
      print("Erro de plataforma durante a autenticação: $e");
      return false;
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
