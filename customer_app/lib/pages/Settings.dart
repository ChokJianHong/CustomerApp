import 'package:customer_app/assets/components/settingItems.dart';
import 'package:customer_app/assets/components/textbox.dart';
import 'package:customer_app/core/app_colors.dart';
import 'package:customer_app/pages/Sign_In.dart';
import 'package:customer_app/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:customer_app/API/getCustToken.dart';

class Setting extends StatefulWidget {
  final String token;
  const Setting({super.key, required this.token});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String customerName = "Loading...";
  String customerEmail = "Loading...";

  @override
  void initState() {
    super.initState();
    _fetchCustomerDetails();
  }

  Future<void> _fetchCustomerDetails() async {
    print('Token: ${widget.token}'); // Debugging line

    try {
      // Fetch customer details using the token
      final customerDetails =
          await CustomerToken().getCustomerByToken(widget.token);
      print('Customer details: $customerDetails'); // Debugging line

      // Decode the token to extract customer ID, if needed
      Map<String, dynamic> decodedToken = JwtDecoder.decode(widget.token);
      print('Decoded Token: $decodedToken'); // Debugging line

      if (!decodedToken.containsKey('userId')) {
        throw Exception('Token does not contain userId');
      }

      // Set state to update the UI with the customer's name and email
      setState(() {
        customerName = customerDetails['data']['name'] ?? 'Unknown Name';
        customerEmail = customerDetails['data']['email'] ?? 'Unknown Email';
      });
    } catch (error) {
      print('Error fetching customer details: $error');
      setState(() {
        customerName = 'Error loading name';
        customerEmail = 'Error loading email';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Account Settings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.darkTeal,
      ),
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          // Profile Section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            color: AppColors.primary,
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(
                      'lib/assets/images/smallProfile.png'), // Replace with your image
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display fetched name
                    Text(
                      customerName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Display fetched email
                    Text(
                      customerEmail,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Settings List
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero, // Remove padding to prevent extra space
              children: [
                Container(
                  color: AppColors.darkTeal,
                  child: Column(
                    children: [
                      SettingItem(
                        title: 'Account',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Profile(
                                token: widget.token,
                              ),
                            ),
                          );
                        },
                      ),
                      const SettingItem(title: 'My Addresses'),
                      const SettingItem(title: 'Notification Settings'),
                      const SettingItem(title: 'App Language'),
                      const SettingItem(title: 'Help Center'),
                      const SettingItem(title: 'About'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Sign Out Button
          Padding(
            padding: const EdgeInsets.only(
                bottom: 16.0), // Adds space around the button
            child: MyButton(
              text: 'Sign Out',
              backgroundColor: AppColors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignInPage(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
