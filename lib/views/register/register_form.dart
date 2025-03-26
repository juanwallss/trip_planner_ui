import 'package:flutter/material.dart';
import 'package:trip_planner_ui/views/widgets/widgets.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    super.key,
    required this.emailController,
    required this.nombreController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  final TextEditingController emailController;
  final TextEditingController nombreController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        SizedBox(height: size.height * 0.06),
        Text(
          'Registro',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: colors.primary,
          ),
        ),
        SizedBox(height: size.height * 0.06),
        MyTextField(
            controller: emailController, 
            hintText: 'Email',
            obscureText: false),
        SizedBox(height: size.height * 0.02),
        MyTextField(
            controller: nombreController, 
            hintText: 'Nombre',
            obscureText: false),
        SizedBox(height: size.height * 0.02),
        MyTextField(
            controller: passwordController,
            hintText: 'Contraseña',
            obscureText: true),
        SizedBox(height: size.height * 0.02),
        MyTextField(
            controller: confirmPasswordController,
            hintText: 'Confirmar Contraseña',
            obscureText: true),
        SizedBox(height: size.height * 0.06),
        MyButton(onTap: () {}, text: 'Registrarse'),
      ]),
    );
  }
}
