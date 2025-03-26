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
}