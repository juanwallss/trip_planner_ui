import 'package:trip_planner_ui/models/activity.dart';

class Itinerary {
  late final int? id;
  final String titulo;
  final String descripcion;
  final String destino;
  final String fechaInicio;
  final String fechaFin;
  final double latitud;
  final double longitud;
  List<Activity> actividades = [];

  Itinerary({
    this.id,
    this.actividades = const [],
    required this.titulo,
    required this.descripcion,
    required this.destino,
    required this.fechaInicio,
    required this.fechaFin,
    required this.latitud,
    required this.longitud,
  });

  static Itinerary fromJson(Map<String, dynamic> json) {
    return Itinerary(
        id: json['id'],
        titulo: json['titulo'],
        descripcion: json['descripcion'],
        destino: json['destino'],
        fechaInicio: json['fechaInicio'],
        fechaFin: json['fechaFin'],
        latitud: json['latitud'],
        longitud: json['longitud'],
        actividades: (json['actividades'] as List<dynamic>? ?? [])
            .map((activityJson) => Activity.fromJson(activityJson))
            .toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'destino': destino,
      'fechaInicio': fechaInicio,
      'fechaFin': fechaFin,
      'latitud': latitud,
      'longitud': longitud,
      'actividades': actividades.map((activity) => activity.toJson()).toList(),
    };
  }
}
