import 'package:flutter/material.dart';

class CustomExpansionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final Color iconColor;
  final Color textColor;

  // Updated constructor with optional parameters for icon and text color
  const CustomExpansionTile(
    this.title,
    this.icon,
    this.child, {
    super.key,
    this.iconColor = Colors.white, // Default color to white if not provided
    this.textColor = Colors.white, // Default color to white if not provided
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        children: [
          Icon(
            icon,
            color: iconColor, // Use iconColor parameter
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              color: textColor, // Use textColor parameter
            ),
          ),
        ],
      ),
      children: [
        child,
        const SizedBox(height: 30),
      ],
    );
  }
}
