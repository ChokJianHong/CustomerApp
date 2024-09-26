import 'package:customer_app/Assets/components/button.dart';
import 'package:customer_app/pages/Sign_In.dart';
import 'package:flutter/material.dart';
import 'package:customer_app/core/configs/theme/app_colors.dart';
import 'package:customer_app/API/registerAPI.dart'; // Ensure you import your API class

class ItemRegister extends StatefulWidget {
  final String username;
  final String email;
  final String phone;
  final String password;

  const ItemRegister({
    super.key,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    required String location,
  });

  @override
  _ItemRegisterState createState() => _ItemRegisterState();
}

class _ItemRegisterState extends State<ItemRegister> {
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  final TextEditingController _alarmBrandController = TextEditingController();
  final TextEditingController _autoGateBrandController =
      TextEditingController();
  final TextEditingController _alarmWarrantyController =
      TextEditingController();

  DateTime? _selectedAlarmWarranty;
  DateTime? _selectedGateWarranty;
  bool _isSubmitting = false; // Track submission state

  @override
  void dispose() {
    _alarmBrandController.dispose();
    _autoGateBrandController.dispose();
    _alarmWarrantyController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context,
      TextEditingController controller, bool isAlarm) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      String formattedDate =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      controller.text = formattedDate; // Update the TextField

      // Store the selected date
      if (isAlarm) {
        _selectedAlarmWarranty = pickedDate;
      } else {
        _selectedGateWarranty = pickedDate;
      }
    }
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true; // Disable button
      });

      try {
        // Collect the values from your text fields and date pickers
        String alarmBrand = _alarmBrandController.text;
        String gateBrand = _autoGateBrandController.text;

        // Check for selected dates
        if (_selectedAlarmWarranty == null) {
          _showErrorDialog('Please select both warranty dates.');
          return;
        }

        // Format the warranty dates as strings
        String alarmWarranty =
            "${_selectedAlarmWarranty!.year}-${_selectedAlarmWarranty!.month.toString().padLeft(2, '0')}-${_selectedAlarmWarranty!.day.toString().padLeft(2, '0')}";

        // Call the register function with the collected values
        final response = await RegisterAPI().registerCustomer(
          widget.email,
          widget.password,
          widget.username,
          widget.phone,
          'Location',
          alarmBrand,
          gateBrand,
          alarmWarranty,
        );

        // Handle the response
        if (response['message'] == 'User created successfully') {
          // Navigate to the next screen if registration is successful
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignInPage()),
          );
        } else {
          // Show error message if registration failed
          _showErrorDialog('Registration failed: ${response['message']}');
        }
      } catch (e) {
        _showErrorDialog('An error occurred during registration: $e');
      } finally {
        setState(() {
          _isSubmitting = false; // Re-enable button
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "Alarm System",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.lightpurple,
                    ),
                  ),
                ),
                Card(
                  color: AppColors.secondary,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _alarmBrandController,
                          decoration: InputDecoration(
                            hintText: 'Alarm Brand',
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the alarm brand';
                            }
                            return null; // Return null if valid
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _alarmWarrantyController,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: 'Alarm Warranty Date',
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: () => _selectDate(
                                  context, _alarmWarrantyController, true),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select the alarm warranty date';
                            }
                            return null; // Return null if valid
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "AutoGate System",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.lightpurple,
                    ),
                  ),
                ),
                Card(
                  color: AppColors.secondary,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _autoGateBrandController,
                          decoration: InputDecoration(
                            hintText: 'AutoGate Brand',
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: MyButton(
                      text: _isSubmitting ? "Submitting..." : "Submit",
                      onTap: _isSubmitting ? null : _onSubmit,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
