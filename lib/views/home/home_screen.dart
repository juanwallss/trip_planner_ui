import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner_ui/models/itinerary.dart';
import 'package:trip_planner_ui/presentation/home/home_presenter.dart';
import 'package:trip_planner_ui/provider/itinerary_provider.dart';
import 'package:trip_planner_ui/views/widgets/widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const String screenName = 'home_screen';

  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final HomePresenter presenter;
  late Future<List<Itinerary>> itinerariesFuture;

  @override
  void initState() {
    super.initState();
    presenter = HomePresenter(ref);
    presenter.getUser();
    itinerariesFuture = presenter.getItineraries();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var itineraries = ref.watch(itinerariesProvider);

    // if (itineraries.isEmpty) {
    //   itineraries = presenter.getItineraries() as List<Itinerary>;
    // }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Itinerarios'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.logout_rounded),
          onPressed: () => _showLogoutDialog(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed('itinerary_screen');
        },
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: itineraries.isEmpty
            ? const Text(
                'Crea tu primer Itinerario!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              )
            : ListView(
                children: itineraries.map((itinerary) {
                  return CardWidget(
                    title: itinerary.titulo,
                    subtitle: itinerary.descripcion,
                    onEdit: () {
                      context.pushNamed(
                        'itinerary_detail_screen',
                        pathParameters: {'id': itinerary.id.toString()},
                      );
                    },
                    onDelete: () {
                      // TODO: Implement delete
                      _showDeleteDialog(context, itinerary.id);
                    },
                  );
                }).toList(),
              ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int? id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar Itinerario'),
        content: const Text('¿Estás seguro de que quieres eliminar este itinerario?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              presenter.deleteItinerary(id, context);
            },
            child: const Text('Eliminar'),  
          ),
        ],
      ),);}

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await presenter.logOut(context);
            },
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }
}
