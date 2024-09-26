import 'package:customer_app/Assets/components/CategoryButton.dart';
import 'package:customer_app/Assets/components/Divider.dart';
import 'package:customer_app/Assets/components/button.dart';
import 'package:customer_app/core/configs/theme/app_colors.dart';
import 'package:customer_app/pages/ConfirmationRequest.dart';
import 'package:customer_app/pages/HomePage.dart';
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HomePage(token: widget.token,)));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CATEGORIES Section
              _buildSectionTitle('CATEGORIES', Icons.category),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  categoryButton(
                    label: 'Alarm System',
                    imagePath: 'lib/Assets/photos/Alarm.png',
                    isSelected: isAlarmSelected,
                    onTap: () {
                      setState(() {
                        isAlarmSelected = true;
                        isAutogateSelected = false;
                      });
                    },
                  ),
                  categoryButton(
                    label: 'AutoGate System',
                    imagePath: 'lib/Assets/photos/Autogate.png',
                    isSelected: isAutogateSelected,
                    onTap: () {
                      setState(() {
                        isAutogateSelected = true;
                        isAlarmSelected = false;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const ADivider(),
              const SizedBox(height: 10),

              // DATE & TIME Section
              _buildSectionTitle('DATE & TIME', Icons.calendar_today),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: _selectDate,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      selectedDate != null
                          ? 'Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}'
                          : 'Select Date',
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _selectTime,
                    icon: const Icon(Icons.access_time),
                    label: Text(
                      selectedTime != null
                          ? 'Time: ${selectedTime!.format(context)}'
                          : 'Select Time',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const ADivider(),

              // EMERGENCY LEVEL Section
              _buildSectionTitle('EMERGENCY LEVEL', Icons.warning),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildEmergencyButton('STANDARD', Colors.green),
                  _buildEmergencyButton('URGENT', Colors.orange),
                  _buildEmergencyButton('EMERGENCY', Colors.red),
                ],
              ),
              const SizedBox(height: 20),
              const ADivider(),

              // PROBLEM DESCRIPTION Section
              _buildSectionTitle('PROBLEM DESCRIPTION', Icons.description),
              const SizedBox(height: 10),
              _buildDescriptionField(),
              const SizedBox(height: 20),
              const ADivider(),

              // PICTURE OF PROBLEM Section
              _buildSectionTitle('PICTURE OF PROBLEM', Icons.camera_alt),
              Container(
                width: double.infinity,
                color: AppColors.secondary,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.camera),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  label: const Text('Insert Picture',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),

              // LOCATION Section
              _buildSectionTitle('LOCATION', Icons.location_on),
              ElevatedButton.icon(
                onPressed: _selectLocation,
                icon: const Icon(Icons.map),
                label: Text(selectedLocation ?? 'Select Location'),
              ),
              const SizedBox(height: 20),

              // Continue Button
              MyButton(
                text: 'Continue',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConfirmationRequest(token: widget.token,)),
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
  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }

  // Emergency Button Widget with Color Change
  // Emergency Button Widget with Animated Color Change
  Widget _buildEmergencyButton(String label, Color color) {
    final isSelected = selectedEmergencyLevel == label;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300), // Animation duration
      curve: Curves.easeInOut, // Smooth curve for animation
      decoration: BoxDecoration(
        color: isSelected ? color.withOpacity(0.8) : Colors.grey[300],
        borderRadius: BorderRadius.circular(8), // Optional: Rounded corners
        boxShadow: isSelected
            ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 10)]
            : [],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors
              .transparent, // Set the background transparent to let the AnimatedContainer handle color
          shadowColor:
              Colors.transparent, // Remove default shadow to use custom shadow
          elevation: 0, // Remove default elevation
        ),
        onPressed: () {
          setState(() {
            selectedEmergencyLevel = label;
          });
        },
        child: Text(
          label,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  // Description Field Widget
  Widget _buildDescriptionField() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          maxLines: null,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Describe the issue here...',
          ),
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
