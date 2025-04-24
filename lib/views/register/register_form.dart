import 'package:flutter/material.dart';
import 'package:trip_planner_ui/presentation/register/register_presenter.dart';
import 'package:trip_planner_ui/views/widgets/widgets.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final RegisterPresenter presenter = RegisterPresenter();

  late TextEditingController emailController;
  late TextEditingController nombreController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  bool isLoading = false; // State to track loading
  String? emailError;
  String? nombreError;
  String? passwordError;
  String? confirmPasswordError;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    nombreController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    nombreController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void toggleLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  bool validateFields() {
    setState(() {
      emailError = presenter.validateEmail(emailController.text);
      nombreError = presenter.validateName(nombreController.text);
      passwordError = presenter.validatePassword(passwordController.text);
      confirmPasswordError = presenter.validateConfirmPassword(
        passwordController.text,
        confirmPasswordController.text,
      );
    });

    return emailError == null &&
        nombreError == null &&
        passwordError == null &&
        confirmPasswordError == null;
  }

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
          obscureText: false,
          errorText: emailError,
        ),
        SizedBox(height: size.height * 0.01),
        MyTextField(
          controller: nombreController,
          hintText: 'Nombre',
          obscureText: false,
          errorText: nombreError,
        ),
        SizedBox(height: size.height * 0.01),
        MyTextField(
          controller: passwordController,
          hintText: 'Contraseña',
          obscureText: true,
          errorText: passwordError,
        ),
        SizedBox(height: size.height * 0.01),
        MyTextField(
          controller: confirmPasswordController,
          hintText: 'Confirmar Contraseña',
          obscureText: true,
          errorText: confirmPasswordError,
        ),
        SizedBox(height: size.height * 0.06),
        isLoading
            ? const CircularProgressIndicator() // Show loader when loading
            : MyButton(
                onTap: () async {
                  if (validateFields()) {
                    toggleLoading(true); // Start loading
                    await presenter.register(
                      emailController.text,
                      nombreController.text,
                      passwordController.text,
                      confirmPasswordController.text,
                      context,
                    );
                    toggleLoading(false); // Stop loading
                  }
                },
                text: 'Registrarse',
              ),
      ]),
    );
  }
}
