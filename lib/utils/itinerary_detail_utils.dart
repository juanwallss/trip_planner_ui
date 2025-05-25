import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class ItineraryDetailUtils {
  static String parseDate(String date) {
    final parsedDate = DateTime.parse(date);
    return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
  }

  static String formatTripDetails(dynamic itinerary) {
    final StringBuffer buffer = StringBuffer();

    buffer.writeln('🧳 DETALLES DEL VIAJE 🧳');
    buffer.writeln('------------------------');
    buffer.writeln('');

    buffer.writeln('📍 Destino: ${itinerary.destino}');
    buffer.writeln('🗒️ Título: ${itinerary.titulo}');
    buffer.writeln(
        '📅 Fechas: ${ItineraryDetailUtils.parseDate(itinerary.fechaInicio)} - ${ItineraryDetailUtils.parseDate(itinerary.fechaFin)}');
    buffer.writeln('');

    buffer.writeln('📝 Descripción:');
    buffer.writeln(itinerary.descripcion);
    buffer.writeln('');

    if (itinerary.actividades.isNotEmpty) {
      buffer.writeln('📋 Actividades:');
      for (int i = 0; i < itinerary.actividades.length; i++) {
        final activity = itinerary.actividades[i];
        buffer.writeln('');
        buffer.writeln('${i + 1}. ${activity.titulo}');
        buffer.writeln('   ${activity.descripcion}');
        final activityDate =
            '${activity.fecha.day}/${activity.fecha.month}/${activity.fecha.year}';
        final activityTime =
            '${activity.hora.hour.toString().padLeft(2, '0')}:${activity.hora.minute.toString().padLeft(2, '0')}';
        buffer.writeln('   📅 $activityDate ⏰ $activityTime');
      }
    }

    buffer.writeln('');
    buffer.writeln('------------------------');
    buffer.writeln('Compartido desde My Trip Planner App');

    return buffer.toString();
  }

  static void copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Detalles del viaje copiados al portapapeles'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }
}
