import 'package:flutter/material.dart';
import 'package:trip_planner_ui/views/login/login_form.dart';

class LoginScreen extends StatelessWidget {
  static const String screenName = 'login_screen';
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const TopLoginScreen(),
            LoginForm(),
          ],
        ),
      ),
    );
  }
}


class TopLoginScreen extends StatelessWidget {
  const TopLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Trip Planner',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: colors.primary,
            ),
          ),
          Image.asset(
            'assets/images/travel_illustration.png',
            height: size.height * 0.3,
          ),
        ],
      ),
    );
  }
}
