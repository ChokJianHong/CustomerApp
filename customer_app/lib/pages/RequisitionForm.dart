import 'dart:io';
import 'package:customer_app/API/JWT.dart';
import 'package:customer_app/API/orderAPI.dart';
import 'package:customer_app/Assets/Model/OrderModel.dart';
import 'package:customer_app/Assets/components/Divider.dart';
import 'package:customer_app/Assets/components/button.dart';
import 'package:customer_app/Assets/components/catergory_buttons.dart';
import 'package:customer_app/core/configs/theme/app_colors.dart';
import 'package:customer_app/pages/ConfirmationRequest.dart';
import 'package:customer_app/pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RequisitionForm extends StatefulWidget {
  final String token;
  final OrderAPI orderService = OrderAPI();

  RequisitionForm({super.key, required this.token});

  @override
  State<RequisitionForm> createState() => _RequisitionFormState();
}

class _RequisitionFormState extends State<RequisitionForm> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedLocation;
  String? selectedEmergencyLevel;
  String? problemDescription;
  String? selectedCategory; // Now tracks selected category from CategoryButtons

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        print('Selected Date: $selectedDate'); // Debugging line
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime:
          selectedTime ?? TimeOfDay.now(), // Use selected time if available
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        print('Selected Time: $selectedTime'); // Debugging line
      });
    }
  }

  Future<void> _selectLocation() async {
    setState(() {
      selectedLocation = 'Location selected'; // Update with actual location
    });
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(token: widget.token),
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04,
          vertical: size.height * 0.02,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('CATEGORIES', Icons.category, size),
              SizedBox(height: size.height * 0.015),

              // Use CategoryButtons widget here
              CategoryButtons(
                onCategorySelected: (category) {
                  setState(() {
                    selectedCategory = category; // Update selected category
                  });
                },
              ),
              SizedBox(height: 20),

              // Display selected category
              if (selectedCategory != null)
                Text(
                  'Selected Category: $selectedCategory',
                  style: TextStyle(fontSize: 16, color: AppColors.primary),
                ),

              SizedBox(height: size.height * 0.03),
              const ADivider(),
              SizedBox(height: size.height * 0.03),

              // DATE & TIME Section
              _buildSectionTitle('DATE & TIME', Icons.calendar_today, size),
              SizedBox(height: size.height * 0.015),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ElevatedButton.icon(
                        onPressed: _selectDate,
                        icon: const Icon(Icons.calendar_today),
                        label: Text(
                          selectedDate != null
                              ? 'Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}'
                              : 'Select Date',
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _selectTime,
                      icon: const Icon(Icons.access_time),
                      label: Text(
                        selectedTime != null
                            ? 'Time: ${selectedTime!.format(context)}'
                            : 'Select Time',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.03),
              const ADivider(),

              // EMERGENCY LEVEL Section
              _buildSectionTitle('EMERGENCY LEVEL', Icons.warning, size),
              SizedBox(height: size.height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildEmergencyButton('STANDARD', Colors.green, size),
                  _buildEmergencyButton('URGENT', Colors.orange, size),
                  _buildEmergencyButton('EMERGENCY', Colors.red, size),
                ],
              ),
              SizedBox(height: size.height * 0.03),

              // PROBLEM DESCRIPTION Section (Collapsible)
              ExpansionTile(
                title: _buildSectionTitle(
                    'PROBLEM DESCRIPTION', Icons.description, size),
                children: [
                  _buildDescriptionField(size),
                  SizedBox(height: size.height * 0.03),
                ],
              ),

              // PICTURE OF PROBLEM Section (Collapsible)
              ExpansionTile(
                title: _buildSectionTitle(
                    'PICTURE OF PROBLEM', Icons.camera_alt, size),
                children: [
                  Container(
                    width: double.infinity,
                    color: AppColors.secondary,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.camera),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      label: const Text('Insert Picture',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                ],
              ),

              // LOCATION Section
              ExpansionTile(
                title: _buildSectionTitle('LOCATION', Icons.location_on, size),
                children: [
                  ElevatedButton.icon(
                    onPressed: _selectLocation,
                    icon: const Icon(Icons.map),
                    label: Text(selectedLocation ?? 'Select Location'),
                  ),
                  SizedBox(height: size.height * 0.03),
                ],
              ),

              SizedBox(
                  height:
                      size.height * 0.04), // Responsive spacing before button
              // Continue Button
              MyButton(
                text: 'Continue',
                onTap: () async {
                  // Ensure all fields are filled
                  if (selectedDate == null ||
                      selectedTime == null ||
                      selectedLocation == null ||
                      problemDescription == null ||
                      selectedEmergencyLevel == null ||
                      selectedCategory == null) {
                    // Show an error message if fields are missing
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill in all fields!')),
                    );
                    return;
                  }

                  // Combine date and time into a single UTC DateTime
                  final combinedDateTime = getCombinedDateTime();
                  if (combinedDateTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Error with date and time selection!')),
                    );
                    return;
                  }

                  // Prepare order data
                  Map<String, dynamic> orderData = {
                    'order_date': combinedDateTime.toIso8601String(),
                    'location_details': selectedLocation,
                    'urgency_level': selectedEmergencyLevel,
                    'order_detail': problemDescription,
                    'problem_type': selectedCategory,
                  };

                  try {
                    // Call your order creation function with the orderData
                    final result = await OrderAPI.createOrder(
                      token: widget.token,
                      orderData: orderData,
                    );

                    // Print the result to debug the response
                    print("API Response: $result");

                    // Check if the response status is successful
                    if (result['status'] == 'success') {
                      // Navigate to confirmation page or show success message
                      Text("IT WOKS");
                    } else {
                      // Show an error message if the response contains an error
                      String errorMessage =
                          result['message'] ?? 'An error occurred';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $errorMessage')),
                      );
                    }
                  } catch (error) {
                    // Handle any exceptions like network issues or timeout
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Network error: Unable to create order')),
                    );
                    print("Error during API call: $error");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Size size) {
    return Row(
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(width: size.width * 0.02),
        Text(
          title,
          style: TextStyle(fontSize: size.width * 0.045, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildEmergencyButton(String label, Color color, Size size) {
    final isSelected = selectedEmergencyLevel == label;
    return Flexible(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.8) : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 10)]
              : [],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          onPressed: () {
            setState(() {
              selectedEmergencyLevel = label;
            });
          },
          child: Text(label,
              style:
                  TextStyle(color: isSelected ? Colors.white : Colors.black)),
        ),
      ),
    );
  }

  Widget _buildDescriptionField(Size size) {
    return TextField(
      onChanged: (value) {
        problemDescription = value; // Track description changes
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Describe the problem',
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }

  DateTime? getCombinedDateTime() {
    if (selectedDate != null && selectedTime != null) {
      final now = DateTime.now();
      final combinedDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );
      return combinedDateTime.toUtc(); // Convert to UTC before sending
    }
    return null;
  }
}
