import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart' as geo;
import 'dart:async';

import 'package:trip_planner_ui/views/widgets/my_textfield.dart';

class MapWidget extends StatefulWidget {
  final Function(Map<String, Object>) onLocationSelected; // Callback to return location
  final String? initialCityName; // Optional initial city name
  final double? initialLatitude; // Optional initial latitude
  final double? initialLongitude; // Optional initial longitude
  final Function(Function)? onMapReady; // Callback to provide search function to parent

  const MapWidget({
    super.key,
    required this.onLocationSelected,
    this.initialCityName,
    this.initialLatitude,
    this.initialLongitude,
    this.onMapReady,
  });

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final loc.Location _locationController = loc.Location();
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();
  StreamSubscription<loc.LocationData>? _locationSubscription;

  static const LatLng _defaultCenter = LatLng(32.6245389, -115.4522623);
  LatLng? _currentPosition;
  late CameraPosition initialCameraPosition;  @override
  void initState() {
    super.initState();

    // Set initial position based on props or default
    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      _currentPosition = LatLng(widget.initialLatitude!, widget.initialLongitude!);
      initialCameraPosition = CameraPosition(target: _currentPosition!, zoom: 12.0);
    } else {
      initialCameraPosition = CameraPosition(target: _defaultCenter, zoom: 11.0);
      // Initialize location controller to check for permissions
      _locationController.hasPermission();
    }

    // Set initial search text if city name is provided
    if (widget.initialCityName != null) {
      _searchController.text = widget.initialCityName!;
    }
    
    // Provide searchLocation function to parent widget if callback is provided
    if (widget.onMapReady != null) {
      widget.onMapReady!(searchLocation);
    }
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al obtener la ubicación, favor de verificar el nombre de la ciudad'),
          duration: Duration(seconds: 3),
          backgroundColor: Color.fromARGB(255, 172, 12, 1),
        ),
      );
    }
    throw Exception("No se pudo encontrar la ubicación para la ciudad: $cityName");
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
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Expanded(
          child: GoogleMap(
            initialCameraPosition: initialCameraPosition,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            zoomControlsEnabled : false,
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
        // SizedBox(height: size.height * .03),
        // MyTextField(
        //   controller: _searchController,
        //   hintText: 'Buscar ciudad',
        //   icon: Icons.search,
        //   onIconPressed: () {
        //     searchLocation(_searchController.text);
        //   },
        // ),
      ],
    );
  }
}
