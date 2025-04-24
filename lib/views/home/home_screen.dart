import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner_ui/presentation/home/home_presenter.dart';
import 'package:trip_planner_ui/views/widgets/widgets.dart';

class HomeScreen extends ConsumerWidget {
  static const String screenName = 'home_screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presenter = HomePresenter(ref);
    presenter.getUser();

    final itinerariesFuture = presenter.getItineraries();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Itinerarios',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.logout_rounded),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Cerrar sesión'),
                  content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await presenter.logOut(context);
                      },
                      child: const Text('Cerrar sesión'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed('itinerary_screen');
        },
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: FutureBuilder(
          future: itinerariesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final itineraries = snapshot.data!;
              if (itineraries.isEmpty) {
                return const Text(
                  'Crea tu primer Itinerario!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                );
              }
              return ListView(
                children: itineraries.map((itinerary) {
                  return CardWidget(
                    title: itinerary.titulo,
                    subtitle: itinerary.descripcion,
                    onEdit: () {
                      // Add edit logic here
                    },
                    onDelete: () {
                      // Add delete logic here
                    },
                  );
                }).toList(),
              );
            } else {
              return const Text(
                'Crea tu primer Itinerario!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              );
            }
          },
        ),
      ),
    );
  }
}
