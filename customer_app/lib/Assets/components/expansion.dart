import 'package:flutter/material.dart';


class CustomExpansionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  // Constructor using positional parameters
  const CustomExpansionTile(this.title, this.icon, this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        children: [
          Icon(
            icon,
            color: Colors.white, // Set the icon color to white
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white, // Set the text color to white
            ),
          ),
        ],
      ),
      children: [child, const SizedBox(height: 30)],
    );
  }
}
