import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner_ui/models/activity.dart';
import 'package:trip_planner_ui/views/widgets/my_textfield.dart';

class ActivityDialog extends StatefulWidget {
  final DateTime maxDate; // Add maxDate as a required parameter

  const ActivityDialog({required this.maxDate, Key? key}) : super(key: key);

  @override
  _ActivityDialogState createState() => _ActivityDialogState();
}

class _ActivityDialogState extends State<ActivityDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Agregar Actividad'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyTextField(
            controller: nameController,
            hintText: 'Nombre de la actividad',
          ),
          MyTextField(
            controller: descriptionController,
            hintText: 'Descripción de la actividad',
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () async {
                  final DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: widget.maxDate,
                  );
                  setState(() {
                    selectedDate = date;
                  });
                },
                child: selectedDate == null
                    ? const Text('Seleccionar Fecha')
                    : Text(
                        'Fecha: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                      ),
              ),
              TextButton(
                onPressed: () async {
                  final TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: selectedTime ?? TimeOfDay.now(),
                  );
                  setState(() {
                    selectedTime = time;
                  });
                },
                child: selectedTime == null
                    ? const Text('Seleccionar Hora')
                    : Text(
                        'Hora: ${selectedTime!.hour}:${selectedTime!.minute}',
                      ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            if (nameController.text.isNotEmpty &&
                descriptionController.text.isNotEmpty &&
                selectedDate != null &&
                selectedTime != null) {
              context.pop(
                Activity(
                  titulo: nameController.text,
                  descripcion: descriptionController.text,
                  fecha: selectedDate!,
                  hora: selectedTime!,
                ),
              );
            }
          },
          child: const Text('Agregar'),
        ),
      ],
    );
  }
}
