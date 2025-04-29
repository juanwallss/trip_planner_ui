// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner_ui/models/activity.dart';
import 'package:trip_planner_ui/models/itinerary.dart';
import 'package:trip_planner_ui/presentation/itinerary/itinerary_presenter.dart';
import 'package:trip_planner_ui/provider/user_provider.dart';
import 'package:trip_planner_ui/views/widgets/activity_dialog.dart';
import 'package:trip_planner_ui/views/widgets/widgets.dart';

class ItineraryForm extends ConsumerStatefulWidget {
  ItineraryForm({super.key});
  final ItineraryPresenter presenter = ItineraryPresenter();

  @override
  ConsumerState<ItineraryForm> createState() => _ItineraryFormState();
}

class _ItineraryFormState extends ConsumerState<ItineraryForm> {
  late TextEditingController destinationController;
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController dateRangeController;
  late DateTime? fromDateController;
  late DateTime? toDateController;
  late double latitudeController;
  late double longitudeController;
  List<Activity> activities = [];

  void addActivity(Activity activity) {
    setState(() {
      activities.add(activity);
    });
  }

  void removeActivity(int index) {
    setState(() {
      activities.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    destinationController = TextEditingController();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    dateRangeController = TextEditingController();
    fromDateController = null;
    toDateController = null;
    latitudeController = 0.0;
    longitudeController = 0.0;
  }

  @override
  void dispose() {
    destinationController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    dateRangeController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final size = MediaQuery.of(context).size;

    final user = ref.watch(userProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * .4,
              width: size.width,
              child: MapWidget(
                onLocationSelected: (location) {
                  setState(() {
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
                  width: size.width * .2,
                  onTap: () async {
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
                          '${fromDateController!.day}/${fromDateController!.month}/${fromDateController!.year} - ${toDateController!.day}/${toDateController!.month}/${toDateController!.year}';
                    });
                  },
                ),
                const SizedBox(width: 10),
                if (fromDateController != null && toDateController != null)
                  Text(
                    'Desde: ${fromDateController!.day}/${fromDateController!.month}/${fromDateController!.year} - Hasta: ${toDateController!.day}/${toDateController!.month}/${toDateController!.year}',
                    style: const TextStyle(fontSize: 16),
                  ),
              ],
            ),
            SizedBox(height: size.height * .02),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        addActivity(newActivity);
                      }
                    }
                  },
                  child: const Text('Agregar Actividad'),
                ),
                const SizedBox(width: 10),
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
                          onEdit: () => {},
                          onDelete: () => removeActivity(index),
                        );
                      },
                    ),
                  ),
              ],
            ),
            SizedBox(height: size.height * .01),
            ElevatedButton(
              onPressed: () async {
                final itineraryData = Itinerary(
                  id: 0,
                  titulo: titleController.text,
                  descripcion: descriptionController.text,
                  destino: destinationController.text,
                  fechaInicio: fromDateController.toString(),
                  fechaFin: toDateController.toString(),
                  latitud: latitudeController,
                  longitud: longitudeController,
                  actividades: activities,
                );

                print('Itinerary Data: ${itineraryData.toJson()}');
                Future<bool> success =
                    widget.presenter.createItinerary(itineraryData, user!, ref);
                if (await success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Itinerario guardado con éxito!'),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.green,
                    ),
                  );
                  context.pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error al guardar el itinerario!'),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Guardar Itinerario'),
            ),
          ],
        ),
      ),
    );
  }
}
