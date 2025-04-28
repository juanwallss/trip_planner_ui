import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner_ui/config/services/api_service.dart';
import 'package:trip_planner_ui/provider/user_provider.dart';
import 'package:trip_planner_ui/models/itinerary.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class HomePresenter {
  final ApiService apiService = ApiService();
  final WidgetRef ref;

  HomePresenter(this.ref);

  void getUser() {
    // Logic to get user data from the provider
    final user = ref.read(userProvider);
    if (user != null) {
      // Do something with the user data
      print('User: ${user.nombre}');
    } else {
      print('No user found');
    }
  }

  Future<List<Itinerary>> getItineraries() async {
    final user = ref.read(userProvider);
    if (user == null) {
      print('No user found');
      return [];
    }
    final response = await apiService.get('itineraries/${user.id}');

    if (response.statusCode == 200) {
      final List<dynamic> itinerariesJson = jsonDecode(response.body);
      final itineraries =
          itinerariesJson.map((json) => Itinerary.fromJson(json)).toList();
      print('Itineraries: $itineraries');
      return itineraries.cast<Itinerary>();
    } else {
      print('Error fetching itineraries: ${response.statusCode}');
      print('Response body: ${response.body}');
    }

    return [];
  }

  Future<void> logOut(BuildContext context) async {
    final response = await apiService
        .post('auth/logout', {"userId": ref.read(userProvider)?.id});

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      clearUser();
      context.pushNamed('login_screen');
    } else {
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ha ocurrido un error al cerrar sesión: ${responseBody['message']}'),
          duration: const Duration(seconds: 2),
          backgroundColor: const Color.fromARGB(255, 172, 12, 1),
        ),
      );
    }
  }
}
