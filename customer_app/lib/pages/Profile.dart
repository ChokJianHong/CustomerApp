import 'package:customer_app/API/getCustToken.dart';

import 'package:customer_app/assets/components/profileAttribute.dart';
import 'package:customer_app/assets/components/textbox.dart';
import 'package:customer_app/core/app_colors.dart';
import 'package:customer_app/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class Profile extends StatefulWidget {
  final String token;

  const Profile({super.key, required this.token});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController autoGateController = TextEditingController();
  final TextEditingController alarmController = TextEditingController();
  final TextEditingController alarmWarrantyController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  String? customerId;

  @override
  void initState() {
    super.initState();
    _fetchCustomerDetails(widget.token);
  }

  Future<Map<String, dynamic>> _fetchCustomerDetails(String token) async {
    print('Token: $token');
    try {
      final customerDetails = await CustomerToken().getCustomerByToken(token);
      print('Customer details: $customerDetails');

      // Decode the token to extract customer ID
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      print('Decoded Token: $decodedToken');

      if (!decodedToken.containsKey('userId')) {
        throw Exception('Token does not contain userId');
      }

      customerId = decodedToken['userId'].toString();
      print('CustomerId set to: $customerId'); // Debugging line

      // Initialize controllers with existing data
      setState(() {
        usernameController.text = customerDetails['data']['name'] ?? '';
        emailController.text = customerDetails['data']['email'] ?? '';
        phoneNumberController.text =
            customerDetails['data']['phone_number'] ?? '';
        alarmWarrantyController.text =
            customerDetails['data']['warranty'] ?? '';
        locationController.text = customerDetails['data']['location'] ?? '';
        autoGateController.text =
            customerDetails['data']['auto_gate_brand'] ?? '';
        alarmController.text = customerDetails['data']['alarm_brand'] ?? '';
      });

      return customerDetails;
    } catch (error) {
      print('Error fetching customer details: $error');
      _showErrorDialog('Error fetching customer details: $error');
      throw Exception('Failed to fetch customer details');
    }
  }

  Future<void> _updateProfile() async {
    print('Update Profile called'); // Debugging line
    final String name = usernameController.text;
    final String location = locationController.text;
    final String email = emailController.text;
    final String warranty = alarmWarrantyController.text;
    final String autoGate = autoGateController.text;
    final String alarm = alarmController.text;
    final String phone = phoneNumberController.text;

    if (customerId == null) {
      _showErrorDialog('Customer ID is not available. Please try again later.');
      return;
    }

    print('CustomerId before update: $customerId'); // Debugging line

    try {
      final response = await CustomerToken().updateCustomerProfile(
        widget.token,
        customerId!,
        name,
        email,
        location,
        alarm,
        autoGate,
        phone,
        warranty,
      );

      print('Update response: $response'); // Debugging line
      if (response['status'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Profile updated successfully'),
        ));
        // Navigate back to the home page after saving
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomePage(token: widget.token),
        ));
      } else {
        _handleUpdateError(response);
      }
    } catch (error) {
      print('Error updating profile: $error'); // Debugging line
      _showErrorDialog('Error updating profile: $error');
    }
  }

  void _handleUpdateError(Map<String, dynamic> response) {
    String message = 'Failed to update profile';
    if (response.containsKey('message')) {
      message = response['message'];
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    alarmWarrantyController.dispose();
    locationController.dispose();
    autoGateController.dispose();
    alarmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      backgroundColor: AppColors.primary,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Center(child: Image.asset("lib/assets/images/Profile.png")),
              const SizedBox(height: 10),
              Text(
                usernameController.text,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(height: 20),
              ProfileAttribute(
                  title: "Username", controller: usernameController),
              ProfileAttribute(
                  title: "Email Address", controller: emailController),
              ProfileAttribute(
                  title: "Phone Number", controller: phoneNumberController),
              ProfileAttribute(
                  title: "Location", controller: locationController),
              ProfileAttribute(
                  title: "Alarm Brand", controller: alarmController),
              ProfileAttribute(
                  title: "AutoGate Brand", controller: autoGateController),
              ProfileAttribute(
                  title: "Alarm Warranty Date",
                  controller: alarmWarrantyController),
              MyButton(text: 'Save', onTap: _updateProfile),
            ],
          ),
        ),
      ),
    );
  }
}
