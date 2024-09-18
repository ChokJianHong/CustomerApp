import 'package:customer_app/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileAttribute extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  const ProfileAttribute({super.key,required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.secondary,
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        trailing: Image.asset("lib/pages/arrowRight.png"),
      ),
    );
  }
}