import 'package:customer_app/Assets/components/SettingItem.dart';
import 'package:customer_app/Assets/components/button.dart';
import 'package:customer_app/core/configs/theme/app_colors.dart';
import 'package:customer_app/pages/Profile.dart';
import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings', style: TextStyle(color: Colors.white),),
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
                      'lib/Assets/photos/smallProfile.png'), // Replace with your image
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
                  SettingItem(title: 'Account', onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Profile()),
                      );
                  },),
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
