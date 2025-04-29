// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner_ui/config/services/api_service.dart';
import 'package:trip_planner_ui/models/user_model.dart';
import 'package:trip_planner_ui/provider/user_provider.dart';

class LoginPresenter {
  final ApiService apiService = ApiService();

  void login(String? email, String? password, BuildContext context) async {
    final response = await apiService
        .post('auth/login', {"email": email, "contraseña": password});

    final responseBody  = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final UserModel user = UserModel.fromJson(responseBody);
      setUser(user);
      context.pushNamed('home_screen');
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
