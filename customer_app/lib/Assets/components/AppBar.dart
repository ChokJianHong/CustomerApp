import 'package:customer_app/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:customer_app/pages/Settings.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String token;
  const CustomAppBar({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.deeppurple,
      elevation: 5, // Subtle shadow for better elevation
      leading: IconButton(
        icon: const Icon(Icons.settings, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Setting(token: token)),
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          onPressed: () {
            // Add notification action here
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("No new notifications")),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
