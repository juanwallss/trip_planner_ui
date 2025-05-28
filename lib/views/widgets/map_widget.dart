import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart' as geo;
import 'package:trip_planner_ui/presentation/providers/theme_provider.dart';
import 'dart:async';

class MapWidget extends ConsumerStatefulWidget {
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
  ConsumerState<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends ConsumerState<MapWidget> {
  final loc.Location _locationController = loc.Location();
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();
  StreamSubscription<loc.LocationData>? _locationSubscription;

  // Add map styles for dark and light modes
  String _darkMapStyle = '';
  String _lightMapStyle = '';

  static const LatLng _defaultCenter = LatLng(32.6245389, -115.4522623);
  LatLng? _currentPosition;
  late CameraPosition initialCameraPosition;
  
  @override
  void initState() {
    super.initState();

    // Load map styles
    _loadMapStyles();

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

  // Load map styles from assets
  Future<void> _loadMapStyles() async {
    _darkMapStyle = '''
    [
          {
            "elementType": "geometry",
            "stylers": [
              {"color": "#212121"}
            ]
          },
          {
            "elementType": "labels.icon",
            "stylers": [
              {"visibility": "off"}
            ]
          },
          {
            "elementType": "labels.text.fill",
            "stylers": [
              {"color": "#757575"}
            ]
          },
          {
            "elementType": "labels.text.stroke",
            "stylers": [
              {"color": "#212121"}
            ]
          },
          {
            "featureType": "administrative",
            "elementType": "geometry",
            "stylers": [
              {"color": "#757575"}
            ]
          },
          {
            "featureType": "administrative.country",
            "elementType": "labels.text.fill",
            "stylers": [
              {"color": "#9e9e9e"}
            ]
          },
          {
            "featureType": "administrative.land_parcel",
            "stylers": [
              {"visibility": "off"}
            ]
          },
          {
            "featureType": "administrative.locality",
            "elementType": "labels.text.fill",
            "stylers": [
              {"color": "#bdbdbd"}
            ]
          },
          {
            "featureType": "poi",
            "elementType": "labels.text.fill",
            "stylers": [
              {"color": "#757575"}
            ]
          },
          {
            "featureType": "poi.park",
            "elementType": "geometry",
            "stylers": [
              {"color": "#181818"}
            ]
          },
          {
            "featureType": "poi.park",
            "elementType": "labels.text.fill",
            "stylers": [
              {"color": "#616161"}
            ]
          },
          {
            "featureType": "poi.park",
            "elementType": "labels.text.stroke",
            "stylers": [
              {"color": "#1b1b1b"}
            ]
          },
          {
            "featureType": "road",
            "elementType": "geometry.fill",
            "stylers": [
              {"color": "#2c2c2c"}
            ]
          },
          {
            "featureType": "road",
            "elementType": "labels.text.fill",
            "stylers": [
              {"color": "#8a8a8a"}
            ]
          },
          {
            "featureType": "road.arterial",
            "elementType": "geometry",
            "stylers": [
              {"color": "#373737"}
            ]
          },
          {
            "featureType": "road.highway",
            "elementType": "geometry",
            "stylers": [
              {"color": "#3c3c3c"}
            ]
          },
          {
            "featureType": "road.highway.controlled_access",
            "elementType": "geometry",
            "stylers": [
              {"color": "#4e4e4e"}
            ]
          },
          {
            "featureType": "road.local",
            "elementType": "labels.text.fill",
            "stylers": [
              {"color": "#616161"}
            ]
          },
          {
            "featureType": "transit",
            "elementType": "labels.text.fill",
            "stylers": [
              {"color": "#757575"}
            ]
          },
          {
            "featureType": "water",
            "elementType": "geometry",
            "stylers": [
              {"color": "#000000"}
            ]
          },
          {
            "featureType": "water",
            "elementType": "labels.text.fill",
            "stylers": [
              {"color": "#3d3d3d"}
            ]
          }
        ]
    ''';

    _lightMapStyle = '''
    ''';
  }

  // Set the map style based on the theme
  void _setMapStyle(bool isDarkMode) {
    if (_mapController != null) {
      _mapController!.setMapStyle(isDarkMode ? _darkMapStyle : _lightMapStyle);
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update map style if the map controller is already initialized
    final isDarkMode = ref.read(themeNotifierProvider).isDarkMode;
    if (_mapController != null) {
      _setMapStyle(isDarkMode);
    }
  }
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;

    return Column(
      children: [
        Expanded(
          child: GoogleMap(
            style: isDarkMode ? _darkMapStyle : _lightMapStyle,
            
            initialCameraPosition: initialCameraPosition,            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              _setMapStyle(isDarkMode);
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
