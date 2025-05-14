import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner_ui/models/itinerary.dart';

// Custom StateNotifier to manage itineraries
class ItineraryNotifier extends StateNotifier<List<Itinerary>> {
  ItineraryNotifier() : super([]);

  void setItineraries(List<Itinerary> itineraries) {
    state = itineraries;
  }

  void addItinerary(Itinerary itinerary) {
    print('Adding itinerary: $itinerary');
    state = [itinerary,...state];
    print('Itinerary added: $state');
  }

  void clearItineraries() {
    state = [];
  }

  Itinerary getItineraryById(int id) {
    return state.firstWhere((itinerary) => itinerary.id == id);
  }

  void removeItinerary(int id) {
    state = state.where((itinerary) => itinerary.id != id).toList();
  }

  void updateItinerary(Itinerary itinerary) {
    state = state.map((existingItinerary) {
      if (existingItinerary.id == itinerary.id) {
        return itinerary;
      } else {
        return existingItinerary;
      }
    }).toList();
  }
}

// StateNotifierProvider for itineraries
final itinerariesProvider =
    StateNotifierProvider<ItineraryNotifier, List<Itinerary>>((ref) {
  return ItineraryNotifier();
});