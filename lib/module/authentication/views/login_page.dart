import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../global/global.dart';
import '../../../routes/routes.dart';

class LoginPage extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (_) => const LoginPage());
  }

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome back!',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              10.verticalSpace,
              Text(
                'Login to your account',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              20.verticalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomTextFormField(
                    label: 'Email',
                    controller: _emailController,
                    hint: 'Enter your email',
                    icon: Icons.email,
                    onChanged: (value) {},
                  ),
                  20.verticalSpace,
                  CustomTextFormField(
                    label: 'Password',
                    controller: _passwordController,
                    hint: 'Enter your password',
                    icon: Icons.lock,
                    onChanged: (value) {},
                    obscureText: true,
                  ),
                  40.verticalSpace,
                  PrimaryButton(
                    text: 'Login',
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.home);
                    },
                  ),
                  10.verticalSpace,
                  RichText(
                    text: TextSpan(
                      text: 'Don\'t have an account? ',
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: 'Register',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, Routes.register);
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
