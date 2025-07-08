import 'dart:async';
import 'package:dio/dio.dart';
import 'package:iba_member_app/core/Globals.dart';
import 'package:iba_member_app/core/data/exception_handlers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  final Dio instance;
  final void Function()? onLogout;

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Globals.apiBaseUrl,
    ),
  );

  DioClient({required this.instance, this.onLogout}) {
    _setupInterceptors();
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

        await prefs.setString('auth_token', newAccessToken);
        await prefs.setString('refreshToken', refreshTokenNew);
      } catch (e) {
        await prefs.remove('auth_token');
        await prefs.remove('refreshToken');
        await prefs.remove('email');
        await prefs.remove('password');
        onLogout?.call();
      }
    }
  }

  void _setupInterceptors() {
    instance.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final expiryString = prefs.getString('token_expiry_datetime');
          final nowUtc = DateTime.now().toUtc();

          final expiryTime = DateTime.parse(expiryString!);
          final secondsSinceLastRefresh = expiryTime.difference(nowUtc).inSeconds;

          if (secondsSinceLastRefresh <= 0) {
              await refreshTokenApi();
              final nowUtc = DateTime.now().toUtc();
              final expiryUtc = nowUtc.add(const Duration(seconds: 90));
              await prefs.setString('token_expiry_datetime', expiryUtc.toIso8601String());
          }

          final newToken = prefs.getString('auth_token');
          if (newToken != null) {
            options.headers['Authorization'] = 'Bearer $newToken';
          }

          return handler.next(options);
        },
        onError: (DioException err, handler) async {
          if (err.response?.statusCode == 401) {
            try {
              final prefs = await SharedPreferences.getInstance();
              await refreshTokenApi();
              final newToken = prefs.getString('auth_token');

              if (newToken != null) {
                final requestOptions = err.requestOptions;
                requestOptions.headers['Authorization'] = 'Bearer $newToken';
                final clonedResponse = await instance.fetch(requestOptions);
                return handler.resolve(clonedResponse);
              }
            } catch (_) {
              onLogout?.call(); // logout forçado
            }
          }

          switch (err.type) {
            case DioException.badResponse:
              switch (err.response?.statusCode) {
                case 400:
                  throw BadRequestException(err.requestOptions, err.response);
                case 500:
                  throw InternalServerException(err.requestOptions);
              }
              break;
            default:
          }

          return handler.next(err);
        },
      ),
    );
  }
}
