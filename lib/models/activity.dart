import 'package:flutter/material.dart';

class Activity {
  final int? itineraryId;
  final String titulo;
  final String descripcion;
  final DateTime fecha;
  final TimeOfDay hora;

  Activity({
    this.itineraryId,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.hora,
  });

  static Activity fromJson(Map<String, dynamic> json) {
    return Activity(
      itineraryId: json['itineraryId'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      fecha: DateTime.parse(json['fecha']),
      hora: _timeOfDayFromString(json['hora']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itineraryId': itineraryId,
      'titulo': titulo,
      'descripcion': descripcion,
      'fecha': fecha.toIso8601String(),
      'hora': '${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}',
    };
  }

  static TimeOfDay _timeOfDayFromString(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}
