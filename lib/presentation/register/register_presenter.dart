import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner_ui/config/services/api_service.dart';

class RegisterPresenter {
  final ApiService apiService = ApiService();

  String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'El email no puede estar vacío';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      return 'El formato del email no es válido';
    }
    return null;
  }

  String? validateName(String name) {
    if (name.isEmpty) {
      return 'El nombre no puede estar vacío';
    }
    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'La contraseña no puede estar vacía';
    }
    if (password.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  String? validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'La confirmación de contraseña no puede estar vacía';
    }
    if (password != confirmPassword) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  Future<void> register(String? email, String? name, String? password, String? confirmPassword, BuildContext context) async {
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Las contraseñas no coinciden'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final response = await apiService.post('auth/signup', {
      "email": email,
      "nombre": name,
      "contraseña": password,
    });

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registro exitoso. Por favor, inicia sesión.'),
          duration: Duration(seconds: 2),
        ),
      );
      context.pushNamed('login_screen');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(responseBody['message']),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}