import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner_ui/models/activity.dart';
import 'package:trip_planner_ui/models/itinerary.dart';
import 'package:trip_planner_ui/presentation/itinerary/itinerary_presenter.dart';
import 'package:trip_planner_ui/provider/itinerary_provider.dart';
import 'package:trip_planner_ui/views/widgets/activity_dialog.dart';
import 'package:trip_planner_ui/views/widgets/card_widget.dart';
import 'package:trip_planner_ui/views/widgets/map_widget.dart';
import 'package:trip_planner_ui/views/widgets/my_button.dart';
import 'package:trip_planner_ui/views/widgets/my_textfield.dart';

class ItineraryEditScreen extends ConsumerStatefulWidget {
  static const String screenName = 'itinerary_edit_screen';
  final ItineraryPresenter presenter = ItineraryPresenter();
  final int id;

  ItineraryEditScreen({super.key, required this.id});

  @override
  _ItineraryEditScreenState createState() => _ItineraryEditScreenState();
}

class _ItineraryEditScreenState extends ConsumerState<ItineraryEditScreen> {
  late TextEditingController destinationController;
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController dateRangeController;
  late DateTime? fromDateController;
  late DateTime? toDateController;
  late double latitudeController;
  late double longitudeController;
  List<Activity> activities = [];

  @override
  void initState() {
    super.initState();

    final selectedItinerary = ref
        .read(itinerariesProvider)
        .firstWhere((itinerary) => itinerary.id == widget.id);

    activities = List.from(selectedItinerary.actividades);

    destinationController =
        TextEditingController(text: selectedItinerary.destino);
    titleController = TextEditingController(text: selectedItinerary.titulo);
    descriptionController =
        TextEditingController(text: selectedItinerary.descripcion);
    fromDateController = DateTime.parse(selectedItinerary.fechaInicio);
    toDateController = DateTime.parse(selectedItinerary.fechaFin);
    dateRangeController = TextEditingController(
        text:
          'Desde: ${fromDateController!.day}/${fromDateController!.month}/${fromDateController!.year} \n Hasta: ${toDateController!.day}/${toDateController!.month}/${toDateController!.year}');
    latitudeController = selectedItinerary.latitud;
    longitudeController = selectedItinerary.longitud;
  }

  @override
  void dispose() {
    destinationController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    dateRangeController.dispose();
    toDateController = null;
    fromDateController = null;
    latitudeController = 0.0;
    longitudeController = 0.0;
    activities.clear();

    super.dispose();
  }

  void _addActivity(Activity activity) {
    setState(() {
      activities.add(activity);
    });
  }

  void _removeActivity(int index) {
    setState(() {
      activities.removeAt(index);
    });
  }

  void _updateItinerary(BuildContext context) async {
    Future<bool> success = widget.presenter.updateItinerary(
      Itinerary(
        id: widget.id,
        titulo: titleController.text,
        descripcion: descriptionController.text,
        destino: destinationController.text,
        fechaInicio: fromDateController.toString(),
        fechaFin: toDateController.toString(),
        latitud: latitudeController,
        longitud: longitudeController,
        actividades: activities,
      ),
      ref,
    );
    if (await success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Itinerario actualizado con éxito!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
      context.pushNamed('home_screen');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al actualizar el itinerario!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _selectDateRange(BuildContext context) async {
    final pickedRange = await showDateRangePicker(
      locale: const Locale('es', 'ES'),
      context: context,
      currentDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedRange == null) return;
    setState(() {
      fromDateController = pickedRange.start;
      toDateController = pickedRange.end;
      dateRangeController.text =
          'Desde: ${fromDateController!.day}/${fromDateController!.month}/${fromDateController!.year} \n Hasta: ${toDateController!.day}/${toDateController!.month}/${toDateController!.year}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Itinerario'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => {Navigator.pop(context)},
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _updateItinerary(context),
        child: const Icon(Icons.save),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * .4,
                width: size.width,
                child: MapWidget(
                  initialCityName: destinationController.text.isNotEmpty
                      ? destinationController.text
                      : null,
                  initialLatitude:
                      latitudeController != 0.0 ? latitudeController : null,
                  initialLongitude:
                      longitudeController != 0.0 ? longitudeController : null,
                  onLocationSelected: (location) {
                    setState(() {
                      // hacer funcion afuera
                      latitudeController = location['latitude'] as double;
                      longitudeController = location['longitude'] as double;
                      destinationController.text = location['city'] as String;
                    });
                  },
                ),
              ),
              SizedBox(height: size.height * .01),
              MyTextField(
                controller: titleController,
                hintText: 'Titulo',
              ),
              SizedBox(height: size.height * .01),
              MyTextField(
                controller: descriptionController,
                hintText: 'Descripcion',
              ),
              SizedBox(height: size.height * .01),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyButton(
                    icon: Icons.calendar_today,
                    width: size.width * .4,
                    text: 'Fechas',
                    onTap: () => _selectDateRange(context),
                  ),
                  const SizedBox(width: 10),
                  if (fromDateController != null && toDateController != null)
                    Text(
                      dateRangeController.text,
                      style: const TextStyle(fontSize: 16),
                    ),
                ],
              ),
              SizedBox(height: size.height * .02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (activities.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: activities.length,
                        itemBuilder: (context, index) {
                          return CardWidget(
                            title: activities[index].titulo,
                            subtitle: activities[index].descripcion,
                            onDelete: () => _removeActivity(index),
                          );
                        },
                      ),
                    ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      if (toDateController != null) {
                        final newActivity = await showDialog<Activity>(
                          context: context,
                          builder: (context) => ActivityDialog(
                            maxDate: toDateController!,
                            minDate: fromDateController!,
                          ),
                        );
                        if (newActivity != null) {
                          _addActivity(newActivity);
                        }
                      }
                    },
                    child: const Text('Agregar Actividad'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
