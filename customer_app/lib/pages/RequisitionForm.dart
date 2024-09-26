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
  const RequisitionForm({Key? key, required this.token}) : super(key: key);

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

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    timeController.text = TimeOfDay.now().format(context);
  }

  Future<void> _selectDateTime() async {
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
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(token: widget.token)),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.04, vertical: size.height * 0.02),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            _buildSectionTitle('CATEGORIES', Icons.category, size),
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
                  style: TextStyle(fontSize: 16, color: AppColors.primary)),
            const SizedBox(height: 30),
            const ADivider(),
            const SizedBox(height: 30),
            _buildSectionTitle('DATE & TIME', Icons.calendar_today, size),
            const SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: _selectDateTime,
              child: Text(
                '${dateController.text} at ${timeController.text}',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 30),
            const ADivider(),
            _buildSectionTitle('EMERGENCY LEVEL', Icons.warning, size),
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
            _buildExpansionTile('PROBLEM DESCRIPTION', Icons.description,
                _buildDescriptionField()),
            _buildExpansionTile(
                'PICTURE OF PROBLEM', Icons.camera_alt, _buildPictureButton()),
            _buildExpansionTile(
                'LOCATION', Icons.location_on, _buildLocationButton()),
            const SizedBox(height: 40),
            MyButton(
              text: 'Continue',
              onTap: () => _handleContinue(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpansionTile(String title, IconData icon, Widget child) {
    return ExpansionTile(
      title: _buildSectionTitle(title, icon, MediaQuery.of(context).size),
      children: [child, const SizedBox(height: 30)],
    );
  }

  Widget _buildPictureButton() {
    return Container(
      width: double.infinity,
      color: AppColors.secondary,
      child: ElevatedButton.icon(
        onPressed: () {
          // Implement picture upload functionality here
        },
        icon: const Icon(Icons.camera),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
        label:
            const Text('Insert Picture', style: TextStyle(color: Colors.white)),
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

    Map<String, dynamic> orderData = {
      'order_date': dateController.text,
      'order_time': timeController.text,
      'location_details': selectedLocation,
      'urgency_level': selectedEmergencyLevel,
      'order_detail': problemDescription,
      'problem_type': selectedCategory,
    };

    try {
      final result =
          await OrderAPI.createOrder(token: widget.token, orderData: orderData);
      if (result['status'] == 'success') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConfirmationRequest(
                    token: widget.token))); // Navigate to confirmation page
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

  Widget _buildSectionTitle(String title, IconData icon, Size size) {
    return Row(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: size.width * 0.045,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
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
        height: size.height * 0.06, // Set a fixed height for uniformity
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.8) : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextButton(
          onPressed: () {
            setState(() {
              selectedEmergencyLevel = label;
            });
          },
          child: Text(
            label,
            style: TextStyle(
              color: Colors.black, // Change text color to black
              fontSize: size.width * 0.04,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return TextField(
      onChanged: (value) {
        setState(() {
          problemDescription = value;
        });
      },
      maxLines: 3,
      decoration: InputDecoration(
        hintText: 'Describe the problem...',
        hintStyle: TextStyle(color: Colors.black54), // Darker hint text color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: Colors.white), // Change border color to white
        ),
        fillColor: Color.fromARGB(31, 255, 255, 255), // Background color
        filled: true, // Enable filling
      ),
      style: TextStyle(color: Colors.black), // Darker input text color
    );
  }
}
