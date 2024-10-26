import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:customer_app/API/cameraTaken.dart';
import 'package:customer_app/API/createOrder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:customer_app/Assets/components/Divider.dart';
import 'package:customer_app/assets/components/categorybuttons.dart';
import 'package:customer_app/assets/components/expansion.dart';
import 'package:customer_app/assets/components/sectionbar.dart';
import 'package:customer_app/assets/components/textbox.dart';
import 'package:customer_app/core/app_colors.dart';
import 'package:customer_app/pages/Confirmation.dart';
import 'package:customer_app/pages/currentPage.dart';
import 'package:customer_app/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class RequisitionForm extends StatefulWidget {
  final String token;
  const RequisitionForm({super.key, required this.token});

  @override
  _RequisitionFormState createState() => _RequisitionFormState();
}

class _RequisitionFormState extends State<RequisitionForm> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedLocation;
  String? selectedEmergencyLevel;
  String? problemDescription;
  String? selectedCategory;
  final ImagePicker _picker = ImagePicker();
  File? _image;

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  bool isFirstBuild = true;

  @override
  void initState() {
    super.initState();
    // Do not initialize selectedTime here
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


  Future<void> _selectLocation() async {
    // Navigate to the location selection page and wait for the result
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CurrentLocationScreen()),
    );

    // Check if the result is not null and is a Map
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        // Update with the actual location returned
        selectedLocation = result['address']; // Assuming you want the address
        double latitude = result['latitude'];
        double longitude = result['longitude'];

        // You can use latitude and longitude as needed
        print(
            'Selected Location: $selectedLocation, Lat: $latitude, Lon: $longitude');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(token: widget.token)),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.04, vertical: size.height * 0.02),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SectionTitle(
                    title: 'CATEGORIES', icon: Icons.category, size: size),
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
                const ADivider(),
                const SizedBox(height: 30),
                SectionTitle(
                    title: "EMERGENCY LEVEL", icon: Icons.warning, size: size),
                const SizedBox(height: 30),
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
                const ADivider(),
                SectionTitle(
                    title: "DATE & TIME",
                    icon: Icons.calendar_today,
                    size: size),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
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
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 30),
                CustomExpansionTile("Problem Description", Icons.description,
                    _buildDescriptionField()),
                Column(
                  children: [
                    _image != null
                        ? Image.file(_image!)
                        : Placeholder(
                            fallbackHeight: 200.0,
                            fallbackWidth: double.infinity,
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _pickImageFromGallery,
                          child: Text('Select Image'),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: _captureImageWithCamera,
                          child: Text('Take Picture'),
                        ),
                      ],
                    )
                  ],
                ),
                CustomExpansionTile(
                    'LOCATION', Icons.location_on, _buildLocationButton()),
                const SizedBox(height: 40),
                MyButton(
                  text: 'Continue',
                  onTap: () => _handleContinue(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationButton() {
    return ElevatedButton.icon(
      onPressed: _selectLocation,
      icon: const Icon(Icons.map),
      label: Text(selectedLocation ?? 'Select Location'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  bool _validateDateTime(DateTime date, TimeOfDay time) {
    final currentDateTime = DateTime.now();
    final selectedDateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);

    // Check if the selected date and time is within shop hours
    bool isWithinBusinessHours = false;
    if (date.weekday >= 1 && date.weekday <= 5) {
      // Weekdays: 9 AM to 5 PM
      isWithinBusinessHours =
          selectedDateTime.hour >= 9 && selectedDateTime.hour < 17;
    } else {
      // Weekends: 9 AM to 12 PM
      isWithinBusinessHours =
          selectedDateTime.hour >= 9 && selectedDateTime.hour < 12;
    }
    return isWithinBusinessHours && selectedDateTime.isAfter(currentDateTime);
  }

  void _handleContinue() async {
    if (selectedDate == null ||
        selectedTime == null ||
        selectedLocation == null ||
        problemDescription == null ||
        selectedEmergencyLevel == null ||
        selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all fields!')));
      return;
    }

    // Open camera and capture an image
    final imagePath = await _takePicture();
    if (imagePath == null) {
      // If the user cancels the camera, exit the method
      return;
    }



    Map<String, dynamic> orderData = {
      'order_date': dateController.text,
      'order_time': timeController.text,
      'location_detail': selectedLocation,
      'urgency_level': selectedEmergencyLevel,
      'order_detail': problemDescription,
      'problem_type': selectedCategory,
      'order_img': uploadedImageUrl, // Include the uploaded image URL
    };

    try {
      final result =
          await OrderAPI.createOrder(token: widget.token, orderData: orderData);
      if (result['status'] == 'success') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConfirmationRequest(
                      token: widget.token,
                      orderId: null,
                    ))); // Navigate to confirmation page
      } else {
        String errorMessage = result['message'] ?? 'An error occurred';
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $errorMessage')));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Network error: Unable to create order')));
    }
  }

// Method to open the camera and take a picture
  Future<String?> _takePicture() async {
    // Assuming you have already set up the camera controller and initialized it
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      // Create a camera controller
      final cameraController = CameraController(
        firstCamera,
        ResolutionPreset.medium,
      );

      // Initialize the camera
      await cameraController.initialize();

      // Take a picture
      final image = await cameraController.takePicture();

      // Dispose of the controller
      await cameraController.dispose();

      return image.path; // Return the path of the captured image
    } catch (e) {
      print('Error capturing image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to capture image.')));
      return null; // Return null if there's an error
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
          next = next.add(Duration(days: 2));
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
