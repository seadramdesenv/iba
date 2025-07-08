import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:iba_member_app/assets/widgets/auth_check_screen.dart';
import 'package:iba_member_app/features/login/view/login_widget.dart';
import 'package:iba_member_app/pages/default/default_widget.dart';
import 'package:iba_member_app/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupGetIt();

  await getIt.allReady();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Iba Membro',
      debugShowCheckedModeBanner: false,
      locale: const Locale('pt', 'BR'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('pt', 'BR'),
      ],
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.black45,
          colorScheme: const ColorScheme.dark(
            primary: Colors.yellow,
            secondary: Colors.white,
            background: Colors.black87,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.black87)),
      initialRoute: '/',
      routes: {
        '/': (context) => Scaffold(
              body: AuthCheckScreen(),
            ),
        '/login': (context) => const Scaffold(
              body: LoginWidget(),
            ),
        '/default': (context) => const Scaffold(
              body: DefaultWidget(),
            ),
      },
    );
  }
}
