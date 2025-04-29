// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner_ui/config/services/api_service.dart';
import 'package:trip_planner_ui/provider/itinerary_provider.dart';
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
    final itineraries = ref.read(itinerariesProvider);
    if (itineraries.isNotEmpty) {
      print('Itineraries already loaded: $itineraries');
      return itineraries;
    }
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
      ref.read(itinerariesProvider.notifier).setItineraries(itineraries);
      return itineraries.cast<Itinerary>();
    } else {
      print('Error fetching itineraries: ${response.statusCode}');
      print('Response body: ${response.body}');
    }

    return [];
  }

  void deleteItinerary(int? id, BuildContext context) async {
    final response = await apiService.delete('itineraries/$id');
    if (response.statusCode == 200) {
      ref.read(itinerariesProvider.notifier).removeItinerary(id!);
      context.pushNamed('home_screen');
    } else {
      print('Error deleting itinerary: ${response.statusCode}');
      print('Response body: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al eliminar el itinerario'),
          duration: Duration(seconds: 2),
          backgroundColor: Color.fromARGB(255, 172, 12, 1),
        ),
      );
    }
  }

  Future<void> logOut(BuildContext context) async {
    final response = await apiService
        .post('auth/logout', {"userId": ref.read(userProvider)?.id});

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      clearUser();
      ref.read(itinerariesProvider.notifier).clearItineraries();
      context.pushNamed('login_screen');
    } else {
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Ha ocurrido un error al cerrar sesión: ${responseBody['message']}'),
          duration: const Duration(seconds: 2),
          backgroundColor: const Color.fromARGB(255, 172, 12, 1),
        ),
      );
    }
  }
}
