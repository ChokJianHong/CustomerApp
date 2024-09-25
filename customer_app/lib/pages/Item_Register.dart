import 'package:customer_app/Assets/components/button.dart';
import 'package:customer_app/pages/Sign_In.dart';
import 'package:flutter/material.dart';
import 'package:customer_app/core/configs/theme/app_colors.dart';
import 'package:customer_app/API/registerAPI.dart'; // Ensure you import your API class

class ItemRegister extends StatefulWidget {
  const ItemRegister({super.key});

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
  final TextEditingController _autoGateWarrantyController =
      TextEditingController();

  DateTime? _selectedAlarmWarranty;
  DateTime? _selectedGateWarranty;

  @override
  void dispose() {
    _alarmBrandController.dispose();
    _autoGateBrandController.dispose();
    _alarmWarrantyController.dispose();
    _autoGateWarrantyController.dispose();
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
      controller.text =
          formattedDate; // Update the TextField with the selected date

      // Store the selected date
      if (isAlarm) {
        _selectedAlarmWarranty = pickedDate;
      } else {
        _selectedGateWarranty = pickedDate;
      }
    }
  }

  void _onSubmit() async {
    // Validate the form fields before proceeding
    if (_formKey.currentState!.validate()) {
      setState(() {
        // Show loading indicator (you can implement your loading logic here)
      });

      // Collect the values from your text fields and date pickers
      String alarmBrand = _alarmBrandController.text;
      DateTime? alarmWarranty = _selectedAlarmWarranty;
      String gateBrand = _autoGateBrandController.text;
      DateTime? gateWarranty = _selectedGateWarranty;

      try {
        // Call the register function with the collected values
        final response = await RegisterAPI().registerCustomerBrands(
          alarmBrand,
          alarmWarranty,
          gateBrand,
          gateWarranty,
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
        // Hide loading indicator (you can implement your loading logic here)
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
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
            // Wrap with Form widget for validation
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
                        const SizedBox(height: 10),
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the AutoGate brand';
                            }
                            return null; // Return null if valid
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _autoGateWarrantyController,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: 'AutoGate Warranty Date',
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: () => _selectDate(
                                  context, _autoGateWarrantyController, false),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select the AutoGate warranty date';
                            }
                            return null; // Return null if valid
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: MyButton(
                      text: "Submit",
                      onTap: _onSubmit,
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
