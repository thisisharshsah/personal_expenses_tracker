import 'package:flutter/material.dart';

import '../../../global/global.dart';
import '../../../routes/routes.dart';

class SplashPage extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (_) => const SplashPage());
  }

  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, Routes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: const Loading(),
    );
  }
}
