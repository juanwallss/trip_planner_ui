import 'package:flutter/material.dart';
import 'package:trip_planner_ui/views/itinerary/itinerary_form.dart';

class ItineraryScreen extends StatelessWidget {
  static const String screenName = 'itinerary_screen';
  const ItineraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Crea tu itinerario'),
      ),
      body: const ItineraryForm(),
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(onPressed: () {}, child: const Text('Guardar')),
      ],
    );
  }
}
