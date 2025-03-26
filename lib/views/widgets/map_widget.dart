import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart' as geo;
import 'dart:async';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

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

  Future<void> searchLocation(String cityName) async {
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
      }
    } catch (e) {
      print("Error al obtener la ubicación: $e");
    }
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
    return Scaffold(
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: TextField(
          //           controller: _searchController,
          //           decoration: InputDecoration(
          //             hintText: "Ingrese una ciudad",
          //             border: OutlineInputBorder(
          //                 borderRadius: BorderRadius.circular(15)),
          //           ),
          //         ),
          //       ),
          //       IconButton(
          //         icon: Icon(Icons.search),
          //         onPressed: () {
          //           searchLocation(_searchController.text);
          //         },
          //       )
          //     ],
          //   ),
          // ),
          const SizedBox(height: 10),
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
        ],
      ),
    );
  }
}
