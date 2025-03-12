
import 'package:flutter/material.dart';
import 'package:trip_planner_ui/presenter/login/login_presenter.dart';
import 'package:trip_planner_ui/views/widgets/my_button.dart';
import 'package:trip_planner_ui/views/widgets/my_textfield.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required LoginPresenter presenter,
  }) : _presenter = presenter;

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final LoginPresenter _presenter;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Iniciar Sesion',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false),
              const SizedBox(height: 15),
              MyTextField(
                  controller: passwordController,
                  hintText: 'Contraseña',
                  obscureText: true),
              const SizedBox(height: 15),
              MyButton(
                  onTap: () {
                    _presenter.login(emailController.toString(),
                        passwordController.toString());
                  },
                  text: 'Iniciar Sesion'),
            ],
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {},
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