import 'dart:async';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
import 'package:iba_member_app/core/Globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Globals.apiBaseUrl,
    ),
  );

  Future<String?> loginUser(String email, String password) async {
    try {
      final response = await _dio.post(
        '/Auth/Login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final token = response.data['accessToken'];
        final refreshToken = response.data['refreshToken'];

        final jwt = JWT.decode(token);

        var prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
        await prefs.setString('userName', jwt.payload['unique_name']);
        await prefs.setString('password', password);
        await prefs.setString('auth_token', token);
        await prefs.setString('refreshToken', refreshToken);

        final nowUtc = DateTime.now().toUtc();
        final expiryUtc = nowUtc.add(const Duration(seconds: 90));
        await prefs.setString(
            'token_expiry_datetime', expiryUtc.toIso8601String());

        // Timer.periodic(const Duration(minutes: 5), (Timer timer) async {
        //   await refreshTokenApi();
        // });

        return null;
      } else {
        return 'Erro ao fazer login';
      }
    } catch (e) {
      return 'Erro de conexão: $e';
    }
  }

  Future<void> refreshTokenApi() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refreshToken');

    if (refreshToken != null) {
      try {
        final response = await _dio.post(
          '/Auth/RefreshToken',
          data: {'refreshToken': refreshToken},
        );

        final newAccessToken = response.data['accessToken'];
        final refreshTokenNew = response.data['refreshToken'];

        await prefs.setString('refreshToken', refreshTokenNew);
        await prefs.setString('auth_token', newAccessToken);
      } catch (e) {
        await prefs.remove('auth_token');
        await prefs.remove('refreshToken');
        await prefs.remove('email');
        await prefs.remove('password');
      }
    }
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('auth_token');
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('refreshToken');
    await prefs.remove('email');
    await prefs.remove('password');
  }
}
