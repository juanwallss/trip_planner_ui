import 'package:flutter/material.dart';
import 'package:trip_planner_ui/config/theme.dart';
import 'package:trip_planner_ui/views/login/login_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme(0).getTheme(),
      home: const SafeArea(child: LoginScreen()),
    );
  }
}
