import 'package:flutter/material.dart';

import '../module/authentication/authentication.dart';
import '../module/home/home.dart';
import '../module/splash/splash.dart';

class Routes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return SplashPage.route();
      case Routes.login:
        return LoginPage.route();
      case Routes.register:
        return RegisterPage.route();

        case Routes.home:
        return HomePage.route();
      default:
        return NotFoundPage.route();
    }
  }
}

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (_) => const NotFoundPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Not Found'),
      ),
      body: const Center(
        child: Text('Page not found'),
      ),
    );
  }
}
