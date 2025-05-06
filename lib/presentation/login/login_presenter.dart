import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trip_planner_ui/config/services/api_service.dart';
import 'package:trip_planner_ui/models/user_model.dart';
import 'package:trip_planner_ui/provider/user_provider.dart';

class LoginPresenter {
  final ApiService apiService = ApiService();

  void login(String? email, String? password, BuildContext context) async {
    final response = await apiService
        .post('auth/login', {"email": email, "contraseña": password});
    print("Response: ${response}");
    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final UserModel user = UserModel.fromJson(responseBody);
      setUser(user);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', responseBody['token']);
      print(prefs.getString('auth_token'));
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
