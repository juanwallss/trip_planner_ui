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
    var theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedItinerary.titulo),
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
              'Descripción:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: size.width * 0.1),
            ),
            const SizedBox(height: 8),
            Text(
              selectedItinerary.descripcion,
              style: theme.textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Fechas:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: theme.textTheme.headlineSmall?.fontSize),
            ),
            Text('Inicio: ${parseDate(selectedItinerary.fechaInicio)}',
              style: TextStyle(fontSize: size.width * 0.08)),
            Text('Fin: ${parseDate(selectedItinerary.fechaFin)}',
              style: TextStyle(fontSize: size.width * 0.08)),
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

String parseDate(String date) {
  final parsedDate = DateTime.parse(date);
  return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
}
