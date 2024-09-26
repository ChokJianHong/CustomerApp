
import 'package:customer_app/Assets/components/Divider.dart';
import 'package:customer_app/Assets/components/button.dart';
import 'package:customer_app/Assets/components/catergory_buttons.dart';
import 'package:customer_app/core/configs/theme/app_colors.dart';
import 'package:customer_app/pages/ConfirmationRequest.dart';
import 'package:customer_app/pages/homePage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class RequisitionForm extends StatefulWidget {
  final String token;
  const RequisitionForm({super.key, required this.token});

  @override
  State<RequisitionForm> createState() => _RequisitionFormState();
}

class _RequisitionFormState extends State<RequisitionForm> {
  bool isAlarmSelected = false;
  bool isAutogateSelected = false;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedLocation;
  String? selectedEmergencyLevel;

  // Function to select date
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Function to select time
  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  // Function to handle location selection
  Future<void> _selectLocation() async {
    setState(() {
      selectedLocation = 'Location selected'; // Update with actual location
    });
  }

  // Function to handle category selection
  void _onSelectCategory(String category) {
    setState(() {
      if (category == 'Alarm') {
        isAlarmSelected = true;
        isAutogateSelected = false;
      } else if (category == 'Autogate') {
        isAlarmSelected = false;
        isAutogateSelected = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size =
        MediaQuery.of(context).size; // Get screen size for responsiveness

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
                    builder: (context) => HomePage(
                          token: widget.token,
                        )));
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04, // Responsive horizontal padding
          vertical: size.height * 0.02, // Responsive vertical padding
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CATEGORIES Section
              _buildSectionTitle('CATEGORIES', Icons.category, size),
              SizedBox(height: size.height * 0.015), // Responsive spacing

              // Use CategoryButtons widget here
              CategoryButtons(
                isAlarmSelected: isAlarmSelected,
                isAutogateSelected: isAutogateSelected,
                onSelectCategory: _onSelectCategory,
              ),

              SizedBox(height: size.height * 0.03), // Responsive spacing
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
                          backgroundColor: Colors.black),
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConfirmationRequest(
                              token: widget.token,
                            )),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Section Title Widget with Icon
  Widget _buildSectionTitle(String title, IconData icon, Size size) {
    return Row(
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(width: size.width * 0.02), // Responsive icon-text spacing
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: size.width * 0.045, // Responsive font size
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }

  // Emergency Button Widget with Animated Color Change and Responsive Design
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
            elevation: 0,
            padding: const EdgeInsets.symmetric(
                horizontal: 5.0, vertical: 9.0), // Adjust padding
            minimumSize: Size(size.width * 0.28,
                size.height * 0.06), // Increased width to avoid wrapping
          ),
          onPressed: () {
            setState(() {
              selectedEmergencyLevel = label;
            });
          },
          child: FittedBox(
            // Ensures text fits inside button
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: size.width * 0.03, // Slightly adjusted font size
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Description Field Widget
  Widget _buildDescriptionField(Size size) {
    return TextField(
      maxLines: 5,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[800],
        hintText: 'Describe your issue...',
        hintStyle: TextStyle(color: Colors.grey[400]),
        contentPadding: EdgeInsets.symmetric(
          vertical: size.height * 0.02,
          horizontal: size.width * 0.03,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
