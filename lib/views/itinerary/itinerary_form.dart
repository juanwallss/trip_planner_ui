import 'package:flutter/material.dart';
import 'package:trip_planner_ui/views/widgets/widgets.dart';

class ItineraryForm extends StatelessWidget {
  const ItineraryForm({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var destinationController = TextEditingController();
    var titleController = TextEditingController();
    var descriptionController = TextEditingController();
    var dateRangeController = TextEditingController();
    DateTime? fromDateController;
    DateTime? toDateController;
    DateTimeRange? dateRange;

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
                  print('Selected location: $location');
                  destinationController.text = location['city'] as String;
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
            ElevatedButton(
              onPressed: () async {
                final pickedRange = await showDateRangePicker(
                  locale: const Locale('es', 'ES'),
                  context: context,
                  currentDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedRange != null) {
                  dateRange = pickedRange;
                }
                fromDateController = pickedRange?.start;
                toDateController = pickedRange?.end;
                print(fromDateController);
                print(toDateController);
              }, child: const Text('Seleccionar Fechas'),
            ),
            SizedBox(height: size.height * .01),
            if (fromDateController != null)
              Text(
                'Desde: ${dateRange!.start.toLocal()} Hasta: ${dateRange!.end.toLocal()}',
                style: const TextStyle(fontSize: 16),
              ),
            SizedBox(height: size.height * .01),
          ],
        ),
      ),
    );
  }
}
