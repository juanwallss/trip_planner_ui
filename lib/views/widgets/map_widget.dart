import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart' as geo;
import 'dart:async';

import 'package:trip_planner_ui/views/widgets/my_textfield.dart';

class MapWidget extends StatefulWidget {
  final Function(Map<String,Object>) onLocationSelected; // Callback to return location

  const MapWidget({super.key, required this.onLocationSelected});

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final loc.Location _locationController = loc.Location();
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();
  StreamSubscription<loc.LocationData>? _locationSubscription;

  static const LatLng _center = LatLng(32.6245389, -115.4522623);
  LatLng? _currentPosition;
  final CameraPosition initialCameraPosition =
      CameraPosition(target: _center, zoom: 11.0);

  @override
  void initState() {
    super.initState();
  }

  Future<Map<String, Object>> searchLocation(String cityName) async {
    try {
      List<geo.Location> locations = await geo.locationFromAddress(cityName);
      if (locations.isNotEmpty) {
        geo.Location location = locations.first;
        LatLng newLatLng = LatLng(location.latitude, location.longitude);

        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: newLatLng, zoom: 12.0),
          ),
        );

        setState(() {
          _currentPosition = newLatLng;
        });

        widget.onLocationSelected(
          {
            "latitude": location.latitude,
            "longitude": location.longitude,
            "city": cityName,
          },
        );

        return {
          "latitude": location.latitude,
          "longitude": location.longitude,
          "city": cityName,
        };
      }
    } catch (e) {
      print("Error al obtener la ubicación: $e");
    }
    throw Exception(
        "No se pudo encontrar la ubicación para la ciudad: $cityName");
  }

  @override
  void dispose() {
    _locationSubscription?.cancel(); // Cancel the location listener
    _mapController?.dispose(); // Dispose of the map controller
    _searchController.dispose(); // Dispose of the search controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    return Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: initialCameraPosition,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              style: jsonEncode([
                {
                  "elementType": "geometry",
                  "stylers": [
                    {"color": "#242f3e"}
                  ]
                },
                {
                  "elementType": "labels.text.fill",
                  "stylers": [
                    {"color": "#746855"}
                  ]
                },
                {
                  "elementType": "labels.text.stroke",
                  "stylers": [
                    {"color": "#242f3e"}
                  ]
                },
                {
                  "featureType": "administrative.locality",
                  "elementType": "labels.text.fill",
                  "stylers": [
                    {"color": "#d59563"}
                  ]
                },
                {
                  "featureType": "poi",
                  "elementType": "labels.text.fill",
                  "stylers": [
                    {"color": "#d59563"}
                  ]
                },
                {
                  "featureType": "poi.park",
                  "elementType": "geometry",
                  "stylers": [
                    {"color": "#263c3f"}
                  ]
                },
                {
                  "featureType": "poi.park",
                  "elementType": "labels.text.fill",
                  "stylers": [
                    {"color": "#6b9a76"}
                  ]
                },
                {
                  "featureType": "road",
                  "elementType": "geometry",
                  "stylers": [
                    {"color": "#38414e"}
                  ]
                },
                {
                  "featureType": "road",
                  "elementType": "geometry.stroke",
                  "stylers": [
                    {"color": "#212a37"}
                  ]
                },
                {
                  "featureType": "road",
                  "elementType": "labels.text.fill",
                  "stylers": [
                    {"color": "#9ca5b3"}
                  ]
                },
                {
                  "featureType": "road.highway",
                  "elementType": "geometry",
                  "stylers": [
                    {"color": "#746855"}
                  ]
                },
                {
                  "featureType": "road.highway",
                  "elementType": "geometry.stroke",
                  "stylers": [
                    {"color": "#1f2835"}
                  ]
                },
                {
                  "featureType": "road.highway",
                  "elementType": "labels.text.fill",
                  "stylers": [
                    {"color": "#f3d19c"}
                  ]
                },
                {
                  "featureType": "transit",
                  "elementType": "geometry",
                  "stylers": [
                    {"color": "#2f3948"}
                  ]
                },
                {
                  "featureType": "transit.station",
                  "elementType": "labels.text.fill",
                  "stylers": [
                    {"color": "#d59563"}
                  ]
                },
                {
                  "featureType": "water",
                  "elementType": "geometry",
                  "stylers": [
                    {"color": "#17263c"}
                  ]
                },
                {
                  "featureType": "water",
                  "elementType": "labels.text.fill",
                  "stylers": [
                    {"color": "#515c6d"}
                  ]
                },
                {
                  "featureType": "water",
                  "elementType": "labels.text.stroke",
                  "stylers": [
                    {"color": "#17263c"}
                  ]
                }
              ]),
              markers: _currentPosition != null
                  ? {
                      Marker(
                        markerId: MarkerId("searchMarker"),
                        position: _currentPosition!,
                        infoWindow: InfoWindow(title: "Ubicación buscada"),
                      ),
                    }
                  : {},
            ),
          ),
          SizedBox(height: size.height * .03),
          MyTextField(
            controller: _searchController,
            hintText: 'Buscar ciudad',
            icon: Icons.search,
            onIconPressed: () {
              searchLocation(_searchController.text);
            },
          ),
        ],
    );
  }
}
