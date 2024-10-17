import 'package:customer_app/assets/components/settingItems.dart';
import 'package:customer_app/assets/components/textbox.dart';
import 'package:customer_app/core/app_colors.dart';
import 'package:customer_app/pages/profile.dart';
import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  final String token;
  const Setting({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account Settings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.secondary,
      ),
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          // Profile Section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            color: AppColors.primary,
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(
                      'lib/Assets/Images/smallProfile.png'), // Replace with your image
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lisa',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'lisa123@gmail.com',
                      style: TextStyle(
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
            child: Container(
              color: AppColors.secondary,
              child: ListView(
                padding: const EdgeInsets.all(0),
                children: [
                  SettingItem(
                    title: 'Account',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Profile(
                                  token: token,
                                )),
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
          ),

          MyButton(text: 'Sign Out', onTap: () {}),
        ],
      ),
    );
  }
}
