import 'package:customer_app/assets/components/textbox.dart';
import 'package:customer_app/core/app_colors.dart';
import 'package:customer_app/pages/Sign_in.dart';
import 'package:flutter/material.dart';
import 'package:customer_app/API/registerAPI.dart'; // Ensure you import your API class

class ItemRegister extends StatefulWidget {
  final String username;
  final String email;
  final String phone;
  final String password;
  final String location;

  const ItemRegister({
    super.key,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    required this.location,
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
  final TextEditingController _autogateWarrantyController =
      TextEditingController();
  DateTime? _selectedAlarmWarranty;
  DateTime? _selectedAutogateWarranty; // New variable for AutoGate warranty
  bool _isSubmitting = false; // Track submission state

  @override
  void dispose() {
    _alarmBrandController.dispose();
    _autoGateBrandController.dispose();
    _alarmWarrantyController.dispose();
    _autogateWarrantyController.dispose();
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

      // Store the selected date in the appropriate variable
      if (isAlarm) {
        _selectedAlarmWarranty = pickedDate; // Correctly assigning for Alarm
      } else {
        _selectedAutogateWarranty =
            pickedDate; // Correctly assigning for AutoGate
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
        if (_selectedAlarmWarranty == null ||
            _selectedAutogateWarranty == null) {
          _showErrorDialog('Please select both warranty dates.');
          return;
        }

        // Format the warranty dates as strings
        String alarmWarranty =
            "${_selectedAlarmWarranty!.year}-${_selectedAlarmWarranty!.month.toString().padLeft(2, '0')}-${_selectedAlarmWarranty!.day.toString().padLeft(2, '0')}";
        String autogateWarranty =
            "${_selectedAutogateWarranty!.year}-${_selectedAutogateWarranty!.month.toString().padLeft(2, '0')}-${_selectedAutogateWarranty!.day.toString().padLeft(2, '0')}"; // Use the correct variable

        // Call the register function with the collected values
        final response = await RegisterAPI().registerCustomer(
          widget.email,
          widget.password,
          widget.username,
          widget.phone,
          widget.location,
          alarmBrand,
          alarmWarranty,
          autogateWarranty,
          gateBrand,
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
                          style: const TextStyle(color: Colors.white),
                          controller: _alarmBrandController,
                          decoration: InputDecoration(
                            hintText: 'Alarm Brand',
                            hintStyle:
                                const TextStyle(color: Color(0xFF848484)),
                            filled: true,
                            fillColor: const Color(0xFF322C43),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFF9597A3),
                              ),
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
                          style: const TextStyle(color: Colors.white),
                          controller: _alarmWarrantyController,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: 'Alarm Warranty Date',
                            hintStyle:
                                const TextStyle(color: Color(0xFF848484)),
                            filled: true,
                            fillColor: const Color(0xFF322C43),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFF9597A3),
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                              ),
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
                          style: const TextStyle(color: Colors.white),
                          controller: _autoGateBrandController,
                          decoration: InputDecoration(
                            hintText: 'AutoGate Brand',
                            hintStyle:
                                const TextStyle(color: Color(0xFF848484)),
                            filled: true,
                            fillColor: const Color(0xFF322C43),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFF9597A3),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the AutoGate brand';
                            }
                            return null; // Return null if valid
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          controller: _autogateWarrantyController,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: 'AutoGate Warranty Date',
                            hintStyle:
                                const TextStyle(color: Color(0xFF848484)),
                            filled: true,
                            fillColor: const Color(0xFF322C43),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFF9597A3),
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                              ),
                              onPressed: () => _selectDate(
                                  context, _autogateWarrantyController, false),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select the AutoGate warranty date';
                            }
                            return null; // Return null if valid
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lightpurple,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 32,
                      ),
                    ),
                    child: _isSubmitting
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text('Register'),
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
