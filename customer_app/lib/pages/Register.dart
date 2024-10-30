import 'package:customer_app/assets/components/textbox.dart';
import 'package:customer_app/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:customer_app/pages/Item_Register.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final searchController = TextEditingController();
  GoogleMapController? googleMapController;
  List<PlacesSearchResult> placeSuggestions = [];
  bool _isLoading = false; // To handle loading state

  Set<Marker> markers = {};
  LatLng? selectedPosition;
  String? selectedAddress;

  final GoogleMapsPlaces _places = GoogleMapsPlaces(
      apiKey:
          'AIzaSyB_IH9EAWfvFhHvjh7w7EE9ej5yGY5Vr-g'); // Set your API Key here

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    searchController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    const emailPattern = r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!RegExp(emailPattern).hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    const phonePattern = r'^\d{10}$';
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    } else if (!RegExp(phonePattern).hasMatch(value)) {
      return 'Enter a valid phone number (10 digits)';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Let's Create Your Account",
                  style: TextStyle(
                    color: AppColors.lightpurple,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                    _usernameController, 'Username', 'Username is required'),
                const SizedBox(height: 20),
                _buildTextField(
                    _emailController, 'Email Address', 'Email is required',
                    validator: _validateEmail),
                const SizedBox(height: 20),
                _buildTextField(_phoneController, 'Phone Number',
                    'Phone number is required',
                    validator: _validatePhone),
                const SizedBox(height: 20),
                _buildTextField(
                    _passwordController, 'Password', 'Password is required',
                    validator: _validatePassword, obscureText: true),
                const SizedBox(height: 20),
                _buildTextField(_confirmPasswordController, 'Confirm Password',
                    'Confirm your password',
                    validator: _validateConfirmPassword, obscureText: true),
                const SizedBox(height: 20),
                _buildSearchField(),
                const SizedBox(height: 20),
                _buildSuggestionsList(),
                const SizedBox(height: 60),
                _isLoading
                    ? const CircularProgressIndicator()
                    : MyButton(
                        text: 'Continue',
                        backgroundColor: AppColors.secondary,
                        onTap: _onContinue,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hintText, String emptyError,
      {String? Function(String?)? validator, bool obscureText = false}) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF848484)),
        filled: true,
        fillColor: const Color(0xFF322C43),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF9597A3)),
        ),
      ),
      validator: validator ??
          (value) => value == null || value.isEmpty ? emptyError : null,
      obscureText: obscureText,
    );
  }

  Widget _buildSearchField() {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Search Location',
        hintStyle: const TextStyle(color: Color(0xFF848484)),
        filled: true,
        fillColor: const Color(0xFF322C43),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF9597A3)),
        ),
        suffixIcon: IconButton(
          onPressed: _searchLocation,
          icon: const Icon(Icons.search),
        ),
      ),
      onChanged: _getSuggestions,
    );
  }

  Widget _buildSuggestionsList() {
    return placeSuggestions.isNotEmpty
        ? Container(
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
                    onTap: () => _selectSuggestion(placeSuggestions[index]),
                  );
                },
              ),
            ),
          )
        : const SizedBox.shrink();
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
              ?.animateCamera(CameraUpdate.newLatLngZoom(newPosition, 14));
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
    LatLng newPosition =
        LatLng(result.geometry!.location.lat, result.geometry!.location.lng);

    setState(() {
      markers.clear();
      markers.add(Marker(
          markerId: MarkerId(result.placeId),
          position: newPosition,
          infoWindow: InfoWindow(title: result.name)));
      searchController.text = result.formattedAddress ?? '';
      placeSuggestions = [];

      selectedPosition = newPosition;
      selectedAddress = result.formattedAddress;
    });

    googleMapController
        ?.animateCamera(CameraUpdate.newLatLngZoom(newPosition, 14));
  }

  Future<void> _onContinue() async {
    if (_formKey.currentState?.validate() == true) {
      setState(() {
        _isLoading = true;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ItemRegister(
                  username: _usernameController.text,
                  email: _emailController.text,
                  phone: _phoneController.text,
                  password: _passwordController.text,
                  location: searchController.text,
                )),
      );
    }
  }
}
