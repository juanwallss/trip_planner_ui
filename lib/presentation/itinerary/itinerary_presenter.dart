import 'dart:convert';

import 'package:trip_planner_ui/config/services/api_service.dart';
import 'package:trip_planner_ui/models/itinerary.dart';
import 'package:trip_planner_ui/models/user_model.dart';
import 'package:trip_planner_ui/provider/itinerary_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItineraryPresenter {
  final ApiService apiService = ApiService();

  bool isLoading = false;
  bool get loading => isLoading;

  set loading(bool value) {
    isLoading = value;
  }

  Future<bool> createItinerary(Itinerary itinerary, UserModel user, WidgetRef ref) async {
    loading = true;
    bool success = false;
    final response =
        await apiService.post('itineraries/${user.id}', itinerary.toJson());

    if (response.statusCode == 200) {
      Itinerary createdItinerary = Itinerary.fromJson(jsonDecode(response.body));
      final responseBody = response.body;
      success = true;
      ref.read(itinerariesProvider.notifier).addItinerary(createdItinerary); // Ensure ref is passed correctly
    } else {
      print('Error saving itinerary: ${response.statusCode}');
      print('Response body: ${response.body}');
    }

    return success;
  }

  Future<bool> updateItinerary(Itinerary itinerary, WidgetRef ref) async {
    loading = true;
    bool success = false;
    final response =
        await apiService.put('itineraries/${itinerary.id}', itinerary.toJson());

    if (response.statusCode == 200) {
      final responseBody = response.body;
      print('Itinerary updated successfully: $responseBody');
      success = true;
      ref.read(itinerariesProvider.notifier).updateItinerary(itinerary);
    } else {
      print('Error updating itinerary: ${response.statusCode}');
      print('Response body: ${response.body}');
    }

    return success;
  }
}
