import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner_ui/views/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static const String screenName = 'home_screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Itinerarios', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {context.pushNamed('itinerary_screen');},
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CardWidget(
              title: 'Viaje a dinamarca',
              subtitle: 'Viaje con la familia a dinamarca',
              onEdit: () {},
              onDelete: () {},
            ),
            CardWidget(
              title: 'Viaje a turquia',
              subtitle: 'Regalo de cumpleaños para mi esposa',
              onEdit: () {},
              onDelete: () {},
            ),
          ],
        ),
      ),
    );
  }
}
