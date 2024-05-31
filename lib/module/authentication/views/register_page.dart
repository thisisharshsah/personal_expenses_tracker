import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../global/global.dart';
import '../../../routes/routes.dart';

class RegisterPage extends StatelessWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (_) => const RegisterPage());
  }

  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Create an account',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              10.verticalSpace,
              Text(
                'Sign up to get started',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              20.verticalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomTextFormField(
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    icon: Icons.person,
                    onChanged: (value) {},
                  ),
                  20.verticalSpace,
                  CustomTextFormField(
                    label: 'Email',
                    hint: 'Enter your email',
                    icon: Icons.email,
                    onChanged: (value) {},
                  ),
                  20.verticalSpace,
                  CustomTextFormField(
                    label: 'Password',
                    hint: 'Enter your password',
                    icon: Icons.lock,
                    onChanged: (value) {},
                    obscureText: true,
                  ),
                  40.verticalSpace,
                  PrimaryButton(
                    text: 'Register',
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.login);
                    },
                  ),
                  10.verticalSpace,
                  RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, Routes.login);
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
