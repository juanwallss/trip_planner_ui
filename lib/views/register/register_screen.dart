import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner_ui/views/register/register_form.dart';

class RegisterScreen extends StatelessWidget {
  static const String screenName = 'register_screen';
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pushNamed('login_screen');
          },
        ),
      ),
      body: SingleChildScrollView(
        child: RegisterForm(),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.colors,
    required this.icon,
    required this.onPressed,
  });

  final ColorScheme colors;
  final IconData icon;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(colors.primary),
        iconColor: WidgetStateProperty.all(Colors.white),
      ),
      onPressed: onPressed,
    );
  }
}
