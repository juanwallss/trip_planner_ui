import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner_ui/models/activity.dart';
import 'package:trip_planner_ui/views/widgets/my_textfield.dart';

class ActivityDialog extends StatefulWidget {
  final DateTime minDate;
  final DateTime maxDate;

  const ActivityDialog({required this.maxDate, required this.minDate, Key? key})
      : super(key: key);

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
    final colors = Theme.of(context).colorScheme;
    return AlertDialog(
      title: const Text('Agregar Actividad'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyTextField(
            controller: nameController,
            hintText: 'Nombre de la actividad',
          ),
          const SizedBox(height: 10),
          MyTextField(
            controller: descriptionController,
            hintText: 'Descripción de la actividad',
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: widget.minDate,
                    firstDate: widget.minDate,
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
              const SizedBox(height: 10),
              ElevatedButton(
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
        ElevatedButton(
          onPressed: () => context.pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.tertiary,
          ),
          child: const Text('Cancelar',
              style: TextStyle(
                color: Colors.white,
              )),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primary,
          ),
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
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 2),
                  content: Text('Por favor completa todos los campos'),
                ),
              );
            }
          },
          child: const Text('Agregar',
              style: TextStyle(
                color: Colors.white,
              )),
        ),
      ],
    );
  }
}
