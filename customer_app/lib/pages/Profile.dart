import 'package:customer_app/Assets/components/ProfileAttribute.dart';
import 'package:customer_app/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20,),
            Center(child: Image.asset("lib/pages/Profile.png")),
            const SizedBox(height: 10,),
            const Text('Lisa',style: TextStyle(color: Colors.white, fontSize: 20),),
            const SizedBox(height: 20,),
            ProfileAttribute(title: "Username"),
            ProfileAttribute(title: "Email Address"),
            ProfileAttribute(title: "Phone Number"),
            ProfileAttribute(title: "Passwords"),
            ProfileAttribute(title: "Appliances"),
          ],
        ),
      ),
    );
  }
}