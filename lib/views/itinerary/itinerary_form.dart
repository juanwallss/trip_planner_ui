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
    DateTimeRange? dateRange;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: size.height * .4, // Set a fixed height for the MapWidget
            width: size.width * .9,
            child: const MapWidget(),
          ),
          SizedBox(height: size.height * .03),
          MyTextField(
            controller: destinationController,
            hintText: 'Destino',
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: ElevatedButton(
              onPressed: () async {
                final pickedRange = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedRange != null) {
                  dateRange = pickedRange;
                }
              },
              child: Text(dateRange == null
                  ? 'Seleccionar rango de fechas'
                  : 'Desde: ${dateRange!.start.toLocal()} Hasta: ${dateRange!.end.toLocal()}'),
            ),
          ),
        ],
      ),
    );
  }
}
