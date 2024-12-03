import 'dart:async';
import 'package:customer_app/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';

class CurrentLocationScreen extends StatefulWidget {
  final String? initialLocation;
  const CurrentLocationScreen({super.key, this.initialLocation});

  @override
  _CurrentLocationScreenState createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
  @override
  void initState() {
    super.initState();

    if (widget.initialLocation != null) {
      searchController.text = widget.initialLocation!;
      selectedAddress = widget.initialLocation;
    }
  }

  late GoogleMapController googleMapController;
  late TextEditingController searchController = TextEditingController();
  List<PlacesSearchResult> placeSuggestions = [];

  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14,
  );

  Set<Marker> markers = {};
  StreamSubscription<Position>? positionStreamSubscription;
  LatLng? selectedPosition;
  String? selectedAddress;
  bool isLoading = false;

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
        title: const Text(
          'Location',
          style: TextStyle(color: AppColors.lightgrey),
        ),
        backgroundColor: AppColors.darkTeal,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Column(
        children: [
          // Search Bar with rounded style
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              elevation: 5,
              shadowColor: Colors.grey,
              borderRadius: BorderRadius.circular(10),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search Location',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _searchLocation,
                  ),
                ),
                onChanged: _getSuggestions,
              ),
            ),
          ),
          // Suggestions List
          if (placeSuggestions.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              height: 100,
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(10),
                child: ListView.builder(
                  itemCount: placeSuggestions.length.clamp(0, 2),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(placeSuggestions[index].name),
                      subtitle:
                          Text(placeSuggestions[index].formattedAddress ?? ''),
                      onTap: () {
                        _selectSuggestion(placeSuggestions[index]);
                      },
                    );
                  },
                ),
              ),
            ),
          // Map Display
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: initialCameraPosition,
                    markers: markers,
                    zoomControlsEnabled: false,
                    mapType: MapType.normal,
                    onMapCreated: (GoogleMapController controller) {
                      googleMapController = controller;
                    },
                  ),
                  if (isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: _startLocationUpdates,
            label: const Text("Current Location"),
            icon: const Icon(Icons.location_history),
            backgroundColor: Colors.blueAccent,
            heroTag: 'currentLocationFAB',
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            onPressed: () {
              if (selectedAddress != null) {
                Navigator.pop(
                  context,
                  selectedAddress, // Return only the address (location name)
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No location selected')),
                );
              }
            },
            label: const Text("Confirm Location"),
            icon: const Icon(Icons.check),
            backgroundColor: Colors.green,
            heroTag: 'confirmLocationFAB',
          ),
        ],
      ),
    );
  }

  Future<void> _startLocationUpdates() async {
    setState(() => isLoading = true);
    Position position = await _determinePosition();
    setState(() => isLoading = false);

    _updateLocationMarker(position);
    await _getAddressFromCoordinates(position.latitude, position.longitude);

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

    markers.clear();

    markers.add(
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: newPosition,
        infoWindow: const InfoWindow(title: "Current Location"),
      ),
    );

    selectedPosition = newPosition;

    googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(newPosition, 14));

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

  Future<void> _getSuggestions(String input) async {
    if (input.isEmpty) return;
    PlacesSearchResponse response = await _places.searchByText(input);

    setState(() {
      placeSuggestions = response.results;
    });
  }

  void _selectSuggestion(PlacesSearchResult result) {
    LatLng newPosition = LatLng(
      result.geometry!.location.lat,
      result.geometry!.location.lng,
    );

    setState(() {
      markers.clear();
      markers.add(Marker(
        markerId: MarkerId(result.placeId),
        position: newPosition,
        infoWindow: InfoWindow(title: result.name),
      ));
      searchController.text = result.formattedAddress ?? '';
      placeSuggestions = [];

      // Update selectedPosition and selectedAddress
      selectedPosition = newPosition; // Set the selected position
      selectedAddress = result.formattedAddress; // Set the selected address
    });

    googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(newPosition, 14));
  }
}
