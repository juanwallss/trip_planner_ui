import 'package:flutter/material.dart';
import 'package:trip_planner_ui/presentation/login/login_presenter.dart';
import 'package:trip_planner_ui/views/login/login_form.dart';

class LoginScreen extends StatelessWidget {
  static const String screenName = 'login_screen';
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final LoginPresenter _presenter = LoginPresenter();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TopLoginScreen(size: size),
            LoginForm(emailController: emailController, passwordController: passwordController, presenter: _presenter),
          ],
        ),
      ),
    );
  }
}


class TopLoginScreen extends StatelessWidget {
  const TopLoginScreen({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Trip Planner',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.green,
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
