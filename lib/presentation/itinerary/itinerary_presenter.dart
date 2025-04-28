import 'package:trip_planner_ui/config/services/api_service.dart';
import 'package:trip_planner_ui/models/itinerary.dart';
import 'package:trip_planner_ui/models/user_model.dart';
import 'package:trip_planner_ui/provider/user_provider.dart';
import 'package:go_router/go_router.dart';

class ItineraryPresenter {
  final ApiService apiService = ApiService();

  bool isLoading = false;
  bool get loading => isLoading;

  set loading(bool value) {
    isLoading = value;
  }

  Future<bool> createItinerary(Itinerary itinerary, UserModel user) async {
    loading = true;
    bool success = false;
    final response =
        await apiService.post('itineraries/${user.id}', itinerary.toJson());

    if (response.statusCode == 200) {
      final responseBody = response.body;
      print('Itinerary saved successfully: $responseBody');
      success = true;
    } else {
      print('Error saving itinerary: ${response.statusCode}');
      print('Response body: ${response.body}');
    }

    return success;
  }
}
