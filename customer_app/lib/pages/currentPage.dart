import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';

class CurrentLocationScreen extends StatefulWidget {
  const CurrentLocationScreen({Key? key}) : super(key: key);

  @override
  _CurrentLocationScreenState createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
  late GoogleMapController googleMapController;
  late TextEditingController searchController = TextEditingController();

  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14,
  );

  Set<Marker> markers = {};
  StreamSubscription<Position>? positionStreamSubscription;
  LatLng? selectedPosition;
  String? selectedAddress;

  final GoogleMapsPlaces _places = GoogleMapsPlaces(
      apiKey:
          'AIzaSyB_IH9EAWfvFhHvjh7w7EE9ej5yGY5Vr-g'); // Set your API Key here

  @override
  void dispose() {
    positionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Current Location"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search Location',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchLocation();
                  },
                ),
              ),
              onChanged: (value) {
                // Optionally: Call a function to display location suggestions
              },
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: initialCameraPosition,
              markers: markers,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                googleMapController = controller;
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () async {
              _startLocationUpdates();
            },
            label: const Text("Current Location"),
            icon: const Icon(Icons.location_history),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            onPressed: () {
              if (selectedPosition != null && selectedAddress != null) {
                // Return the selected location to the previous page
                Navigator.pop(context, {
                  'latitude': selectedPosition!.latitude,
                  'longitude': selectedPosition!.longitude,
                  'address': selectedAddress
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No location selected')),
                );
              }
            },
            label: const Text("Confirm Location"),
            icon: const Icon(Icons.check),
          ),
        ],
      ),
    );
  }

  Future<void> _startLocationUpdates() async {
    Position position = await _determinePosition();

    // Initially update the marker and search bar to current location and address
    _updateLocationMarker(position);
    await _getAddressFromCoordinates(position.latitude, position.longitude);

    // Listen for location updates
    positionStreamSubscription =
        Geolocator.getPositionStream().listen((Position updatedPosition) {
      _updateLocationMarker(updatedPosition);
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _updateLocationMarker(Position position) {
    LatLng newPosition = LatLng(position.latitude, position.longitude);

    // Clear existing markers
    markers.clear();

    // Add the updated marker
    markers.add(
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: newPosition,
        infoWindow: InfoWindow(title: "Current Location"),
      ),
    );

    selectedPosition = newPosition;

    // Animate camera to the new location
    googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(newPosition, 14));

    // Refresh the UI
    setState(() {});
  }

  Future<void> _getAddressFromCoordinates(
      double latitude, double longitude) async {
    final geocoding =
        GoogleMapsGeocoding(apiKey: 'AIzaSyB_IH9EAWfvFhHvjh7w7EE9ej5yGY5Vr-g');
    GeocodingResponse response = await geocoding
        .searchByLocation(Location(lat: latitude, lng: longitude));

    if (response.status == "OK") {
      setState(() {
        searchController.text =
            response.results[0].formattedAddress ?? 'Address not found';
        selectedAddress = response.results[0].formattedAddress;
      });
    }
  }

  Future<void> _searchLocation() async {
    String query = searchController.text;
    if (query.isNotEmpty) {
      PlacesSearchResponse response = await _places.searchByText(query);
      if (response.results.isNotEmpty) {
        var result = response.results.first;
        LatLng newPosition = LatLng(
            result.geometry!.location.lat, result.geometry!.location.lng);

        // Update the marker and animate to the searched location
        setState(() {
          markers.clear();
          markers.add(Marker(
              markerId: const MarkerId('searchedLocation'),
              position: newPosition));
          googleMapController
              .animateCamera(CameraUpdate.newLatLngZoom(newPosition, 14));

          selectedPosition = newPosition;
          selectedAddress = result.formattedAddress;
        });
      }
    }
  }
}
