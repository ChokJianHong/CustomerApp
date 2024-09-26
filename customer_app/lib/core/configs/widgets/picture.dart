import 'package:customer_app/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PictureButton extends StatelessWidget {
  const PictureButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.secondary,
      child: ElevatedButton(
        onPressed: () {
          // Add image upload functionality
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
        child: const Text(
          'Insert Picture',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
