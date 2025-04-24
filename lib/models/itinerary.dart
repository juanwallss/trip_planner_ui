import 'package:trip_planner_ui/models/activity.dart';

class Itinerary {
  final int id;
  final String titulo;
  final String descripcion;
  final String destino;
  final String fechaInicio;
  final String fechaFin;
  final double latitud;
  final double longitud;
  final String usuarioId;
  List<Activity> activities = [];

  Itinerary(
      {required this.id,
      required this.titulo,
      required this.descripcion,
      required this.destino,
      required this.fechaInicio,
      required this.fechaFin,
      required this.latitud,
      required this.longitud,
      required this.usuarioId});

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
      usuarioId: json['usuarioId'],
    );
  }
}
