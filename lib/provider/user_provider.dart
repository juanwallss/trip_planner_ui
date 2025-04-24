import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner_ui/models/user_model.dart';

var userProvider = StateProvider<UserModel?>((ref) => null);

void setUser(UserModel user) {
  userProvider = StateProvider<UserModel?>((ref) => user);
}

void clearUser() {
  userProvider = StateProvider<UserModel?>((ref) => null);
}