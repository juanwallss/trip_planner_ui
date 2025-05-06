import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner_ui/provider/itinerary_provider.dart';

class ItineraryDetailScreen extends ConsumerWidget {
  static const String screenName = 'itinerary_detail_screen';
  final int id;

  const ItineraryDetailScreen({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItinerary = ref.read(itinerariesProvider).firstWhere((itinerary) => itinerary.id == id);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Itinerario'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed('itinerary_edit_screen', pathParameters: {
            'id': selectedItinerary.id.toString(),
          });
        },
        child: const Icon(Icons.edit),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              selectedItinerary.titulo,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              selectedItinerary.descripcion,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            const Text(
              'Fechas:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Inicio: ${DateTime.parse(selectedItinerary.fechaInicio).toLocal()}'),
            Text('Fin: ${DateTime.parse(selectedItinerary.fechaFin).toLocal()}'),
            const SizedBox(height: 16),
            const Text(
              'Destino:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(selectedItinerary.destino),
            const SizedBox(height: 16),
            if (selectedItinerary.actividades.isNotEmpty) ...[
              const Text(
                'Actividades:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...selectedItinerary.actividades.map(
                (activity) => Card(
                  child: ListTile(
                    title: Text(activity.titulo),
                    subtitle: Text(activity.descripcion),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
