import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner_ui/presentation/login/login_presenter.dart';
import 'package:trip_planner_ui/views/widgets/widgets.dart';

class LoginForm extends StatefulWidget {
  LoginForm({super.key});
  final LoginPresenter presenter = LoginPresenter();


  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    emailController.text = '';
    passwordController.text = '';
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      child: Column(
        children: [
          Column(
            children: [
              const SizedBox(height: 20),
              Text(
                'Iniciar Sesión',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                ),
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),
              const SizedBox(height: 15),
              MyTextField(
                controller: passwordController,
                hintText: 'Contraseña',
                obscureText: true,
              ),
              const SizedBox(height: 15),
              MyButton(
                onTap: () {
                  widget.presenter.login(
                      emailController.text, passwordController.text, context);
                },
                text: 'Iniciar Sesión',
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              context.pushNamed('register_screen');
            },
            child: const Text.rich(
              TextSpan(
                text: 'No tienes cuenta? ',
                children: [
                  TextSpan(
                    text: 'Regístrate aquí.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
