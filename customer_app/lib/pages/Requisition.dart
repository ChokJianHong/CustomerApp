import 'dart:convert';
import 'dart:io';
import 'package:customer_app/API/getCustToken.dart';
import 'package:customer_app/Assets/components/AppBar.dart';
import 'package:customer_app/Assets/components/navbar.dart';
import 'package:customer_app/pages/home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:customer_app/Assets/components/Divider.dart';
import 'package:customer_app/assets/components/categorybuttons.dart';
import 'package:customer_app/assets/components/expansion.dart';
import 'package:customer_app/assets/components/sectionbar.dart';
import 'package:customer_app/assets/components/textbox.dart';
import 'package:customer_app/core/app_colors.dart';
import 'package:customer_app/pages/currentPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:http_parser/http_parser.dart';
import 'package:jwt_decoder/jwt_decoder.dart'; // For specifying file type

class RequisitionForm extends StatefulWidget {
  final String token;
  final String? orderId;
  const RequisitionForm({super.key, required this.token, this.orderId});

  @override
  _RequisitionFormState createState() => _RequisitionFormState();
}

class _RequisitionFormState extends State<RequisitionForm> {
  int _currentIndex = 0;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedLocation;
  String? selectedEmergencyLevel;
  String? problemDescription;
  String? selectedCategory;
  String customerLocation = "Loading..."; // Default text while loading
  bool isLocationFetched = false;
  final ImagePicker _picker = ImagePicker();
  File? _image;

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  bool isFirstBuild = true;

  @override
  void initState() {
    super.initState();
    _fetchAndSetCustomerLocation();
  }

  Future<void> _fetchAndSetCustomerLocation() async {
    try {
      // Fetch the customer location using the token
      String location = await fetchCustomerLocationFromAPI(widget.token);
      setState(() {
        customerLocation = location; // Update the state variable
      });
    } catch (error) {
      print('Error fetching customer location: $error');
      _showErrorDialog('Error fetching customer location: $error');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> fetchCustomerLocationFromAPI(String token) async {
    try {
      // Retrieve customer details using the token
      final customerDetails = await CustomerToken().getCustomerByToken(token);
      print('Customer details: $customerDetails');

      // Decode the token to extract customer ID
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      print('Decoded Token: $decodedToken');

      if (!decodedToken.containsKey('userId')) {
        throw Exception('Token does not contain userId');
      }

      // Extract location directly from customer details
      String location = customerDetails['data']['location'] ?? '';
      print('Customer Location: $location'); // Debugging line

      return location; // Return the location
    } catch (error) {
      throw Exception('Failed to fetch customer location');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize only on the first build
    if (isFirstBuild) {
      selectedTime = TimeOfDay.now(); // Set the initial time only once
      isFirstBuild =
          false; // Set the flag to false after the first initialization
    }
  }

  Future<void> _selectDateTime() async {
    if (selectedEmergencyLevel == 'EMERGENCY' && selectedDate != null) {
      // Do not allow changing date and time for emergency
      return;
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime ?? TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDate = pickedDate;
          selectedTime = pickedTime;
          dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
          timeController.text = selectedTime!.format(context);
        });
      }
    }
  }

  // Function to pick an image from the gallery
  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Function to capture an image with the camera
  Future<void> _captureImageWithCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<Map<String, dynamic>> _uploadImageAndData(
      Map<String, String> orderData) async {
    if (_image == null) {
      throw Exception('No image selected');
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://82.112.238.13:5005/dashboarddatabase/orders'),
      );

      // Add authorization headers if needed
      request.headers['Authorization'] = widget.token;

      // Add the image file to the request
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          _image!.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      // Add the rest of the order data
      orderData.forEach((key, value) {
        request.fields[key] = value;
      });

      // Send the request
      var response = await request.send();

      // Read the server's response
      var responseData = await http.Response.fromStream(response);
      var responseBody = jsonDecode(responseData.body);

      if (response.statusCode == 201) {
        // Return the parsed response
        print(responseBody);
        return responseBody;
      } else {
        print('Upload failed with status: ${response.statusCode}');
        print('Response body: ${responseData.body}');
        throw Exception('Upload failed');
      }
    } catch (e) {
      print('Error uploading image and data: $e');
      throw Exception('Upload failed');
    }
  }

  Future<void> _selectLocation() async {
    // Fetch location name from the token or database
    String? initialLocationName;
    try {
      initialLocationName = await fetchCustomerLocationFromAPI(
          widget.token); // Replace with your actual implementation
      print('Fetched location name: $initialLocationName');
    } catch (e) {
      print('Error fetching location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch initial location.')),
      );
      return;
    }

    // Navigate to CurrentLocationScreen
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CurrentLocationScreen(initialLocation: initialLocationName),
      ),
    );

    // Handle result from CurrentLocationScreen
    if (result != null && result is String) {
      setState(() {
        selectedLocation = result; // Directly use the location name
        print('Selected Location: $selectedLocation');
      });
    }
  }

  void _onTapTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: CustomAppBar(token: widget.token),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.04, vertical: size.height * 0.02),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SectionTitle(
                    title: 'CATEGORIES', icon: Icons.category, size: size),
                const ADivider(),
                const SizedBox(height: 15),
                CategoryButtons(
                  onCategorySelected: (category) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                ),
                if (selectedCategory != null)
                  Text('Selected Category: $selectedCategory',
                      style: const TextStyle(
                          fontSize: 16, color: AppColors.primary)),
                const SizedBox(height: 30),
                SectionTitle(
                    title: "EMERGENCY LEVEL", icon: Icons.warning, size: size),
                const ADivider(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ['STANDARD', 'URGENT', 'EMERGENCY'].map((level) {
                    return _buildEmergencyButton(
                        level,
                        level == 'STANDARD'
                            ? Colors.green
                            : (level == 'URGENT' ? Colors.orange : Colors.red),
                        size);
                  }).toList(),
                ),
                const SizedBox(height: 30),
                SectionTitle(
                    title: "DATE & TIME",
                    icon: Icons.calendar_today,
                    size: size),
                const ADivider(),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal:
                            40), // Increased vertical and horizontal padding
                    minimumSize: Size(
                        size.width * 0.6, 50), // Set minimum width and height
                    maximumSize: Size(size.width * 0.8,
                        80), // Optional: Set maximum width and height
                  ),
                  onPressed: _selectDateTime,
                  child: Text(
                    dateController.text.isEmpty && timeController.text.isEmpty
                        ? 'Pick Date and Pick Time'
                        : '${dateController.text} at ${timeController.text}',
                    style: const TextStyle(
                        color: AppColors.lightgrey, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 30),
                CustomExpansionTile("Problem Description", Icons.description,
                    _buildDescriptionField()),
                SectionTitle(
                    title: 'Camera', icon: Icons.camera_outlined, size: size),
                const ADivider(),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    _image != null
                        ? Image.file(_image!)
                        : const Placeholder(
                            fallbackHeight: 200.0,
                            fallbackWidth: double.infinity,
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.orange),
                          onPressed: _pickImageFromGallery,
                          child: const Text(
                            'Select Image',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.orange),
                          onPressed: _captureImageWithCamera,
                          child: const Text(
                            'Take Picture',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomExpansionTile(
                    'LOCATION',
                    iconColor: AppColors.lightgrey,
                    textColor: AppColors.lightgrey,
                    Icons.location_on,
                    _buildLocationButton()),
                const SizedBox(height: 40),
                MyButton(
                  backgroundColor: AppColors.orange,
                  text: 'Continue',
                  onTap: () => _handleContinue(),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(
        onTap: _onTapTapped,
        currentIndex: _currentIndex,
        token: widget.token,
      ),
    );
  }

  Widget _buildLocationButton() {
    return ElevatedButton.icon(
      onPressed: _selectLocation,
      icon: const Icon(Icons.map),
      label: Text(customerLocation.isNotEmpty
          ? customerLocation
          : 'Select Location'), // Display the current or prompt to select
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(color: Colors.white),
        backgroundColor: AppColors.orange, // Your color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _handleContinue() async {
    // Debugging field values
    print('Debugging Fields:');
    print('selectedDate: $selectedDate');
    print('selectedTime: $selectedTime');
    print('selectedLocation: $selectedLocation');
    print('problemDescription: $problemDescription');
    print('selectedEmergencyLevel: $selectedEmergencyLevel');
    print('selectedCategory: $selectedCategory');
    print('_image: $_image');

    // Check for null fields
    if (selectedDate == null ||
        selectedTime == null ||
        selectedLocation == null ||
        problemDescription == null ||
        selectedEmergencyLevel == null ||
        selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields!')),
      );
      return;
    }

    // Prepare order data
    Map<String, String> orderData = {
      'order_date': dateController.text,
      'order_time': timeController.text,
      'location_detail': selectedLocation!,
      'urgency_level': selectedEmergencyLevel!,
      'order_detail': problemDescription!,
      'problem_type': selectedCategory!,
    };

    try {
      final result = await _uploadImageAndData(orderData);
      print('Response: $result');
      if (result['message'] == 'success') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(token: widget.token),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: ${result['message'] ?? 'Unknown error'}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Network error: Unable to create order')),
      );
    }
  }

  Widget _buildDescriptionField() {
    return TextField(
      onChanged: (value) {
        setState(() {
          problemDescription = value;
        });
      },
      decoration: InputDecoration(
        labelText: 'Describe the problem',
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildEmergencyButton(String label, Color color, Size size) {
    return Flexible(
      // Use Flexible to prevent overflow
      child: TextButton(
        onPressed: () {
          setState(() {
            selectedEmergencyLevel = label;

            final now = DateTime.now();

            if (label == 'EMERGENCY') {
              if (_isShopOpen(now)) {
                // Set the date and time to now for emergency and lock the date
                selectedDate = now;
                selectedTime = TimeOfDay.fromDateTime(now);
                dateController.text =
                    DateFormat('yyyy-MM-dd').format(selectedDate!);
                timeController.text = selectedTime!.format(context);
              } else {
                // Handle case where shop is closed
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'The shop is currently closed. Please choose another time.'),
                  ),
                );

                // Optionally set to next available opening time
                DateTime nextOpening = _getNextOpeningTime(now);
                selectedDate = nextOpening;
                selectedTime = TimeOfDay.fromDateTime(nextOpening);
                dateController.text =
                    DateFormat('yyyy-MM-dd').format(selectedDate!);
                timeController.text = selectedTime!.format(context);
              }
            } else if (label == 'URGENT') {
              if (_isShopOpen(now)) {
                // Allow the customer to choose the time for the same day
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(now),
                ).then((selectedTime) {
                  if (selectedTime != null) {
                    // Create DateTime object for selected time
                    DateTime selectedDateTime = DateTime(now.year, now.month,
                        now.day, selectedTime.hour, selectedTime.minute);

                    if (_isShopOpen(selectedDateTime)) {
                      // Lock the date
                      selectedDate = now; // Keep date as today
                      this.selectedTime = selectedTime; // Update time
                      timeController.text = selectedTime.format(context);
                      dateController.text =
                          DateFormat('yyyy-MM-dd').format(selectedDate!);
                    } else {
                      // Show error if time is outside business hours
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Please select a time within business hours.'),
                        ),
                      );
                    }
                  }
                });
              } else {
                // Handle case where shop is closed
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'The shop is currently closed. Please choose another time.'),
                  ),
                );

                // Optionally set to next available opening time
                DateTime nextOpening = _getNextOpeningTime(now);
                selectedDate = nextOpening;
                selectedTime = TimeOfDay.fromDateTime(nextOpening);
                dateController.text =
                    DateFormat('yyyy-MM-dd').format(selectedDate!);
                timeController.text = selectedTime!.format(context);
              }
            }
          });
        },
        child: Container(
          // Use MediaQuery to set width responsively
          width: size.width * 0.25, // Adjust this as needed
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selectedEmergencyLevel == label ? color : Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selectedEmergencyLevel == label
                    ? Colors.white
                    : Colors.black,
              ),
              overflow: TextOverflow.ellipsis, // Prevent overflow
            ),
          ),
        ),
      ),
    );
  }

// Check if the shop is open based on the current time
  bool _isShopOpen(DateTime dateTime) {
    if (dateTime.weekday >= DateTime.monday &&
        dateTime.weekday <= DateTime.friday) {
      // Weekdays: 9 AM to 5 PM
      return dateTime.hour >= 9 && dateTime.hour < 17;
    } else {
      // Weekends: 9 AM to 12 PM
      return dateTime.hour >= 9 && dateTime.hour < 12;
    }
  }

// Get the next opening time if the shop is closed
  DateTime _getNextOpeningTime(DateTime current) {
    DateTime next;

    if (current.weekday >= DateTime.monday &&
        current.weekday <= DateTime.friday) {
      // Weekdays: if it's after 5 PM, set to next day at 9 AM
      if (current.hour >= 17) {
        next = DateTime(current.year, current.month, current.day + 1, 9);
        // If the next day is a weekend, move to the following Monday at 9 AM
        if (next.weekday == DateTime.saturday) {
          next = next.add(const Duration(days: 2));
        }
      } else if (current.hour < 9) {
        // If before 9 AM on a weekday, set to today at 9 AM
        next = DateTime(current.year, current.month, current.day, 9);
      } else {
        // Shop is open within weekday hours
        next = current;
      }
    } else {
      // Weekends: if it's after 12 PM, set to next weekday at 9 AM
      if (current.hour >= 12 || current.weekday == DateTime.sunday) {
        int daysToMonday = (8 - current.weekday) % 7;
        next = DateTime(
            current.year, current.month, current.day + daysToMonday, 9);
      } else if (current.hour < 9) {
        // If before 9 AM on a weekend, set to today at 9 AM
        next = DateTime(current.year, current.month, current.day, 9);
      } else {
        // Shop is open within weekend hours
        next = current;
      }
    }

    return next;
  }
}
