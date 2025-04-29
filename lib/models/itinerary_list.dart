import 'package:trip_planner_ui/models/itinerary.dart';

class ItineraryList {
  final List<Itinerary> itineraries;

  ItineraryList({
    required this.itineraries,
  });

  factory ItineraryList.fromJson(List<dynamic> json) {
    List<Itinerary> itineraries = [];
    itineraries = json.map((i) => Itinerary.fromJson(i)).toList();

    return ItineraryList(
      itineraries: itineraries,
    );
  }

  void insertItinerary(Itinerary itinerary) {
    itineraries.add(itinerary);
  }
  void removeItinerary(Itinerary itinerary) {
    itineraries.remove(itinerary);
  }
  void removeById(String id) {
    itineraries.removeWhere((itinerary) => itinerary.id == id);
  }
}