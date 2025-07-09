import 'package:flutter/material.dart';
import 'package:iba_member_app/assets/widgets/auth_check_screen.dart';
import 'package:iba_member_app/features/login/view/login_widget.dart';
import 'package:iba_member_app/pages/default/default_widget.dart';

class AppRouter {
  static const String authCheck = '/';
  static const String login = '/login';
  static const String defaultRoute = '/default';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case authCheck:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: AuthCheckScreen(),
          ),
        );
      case login:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: LoginWidget(),
          ),
        );
      case defaultRoute:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: DefaultWidget(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Sem rota definida para ${settings.name}'),
            ),
          ),
        );
    }
  }
}
