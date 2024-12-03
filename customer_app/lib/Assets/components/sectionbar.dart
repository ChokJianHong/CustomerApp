import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  final Size size;

  const SectionTitle({
    required this.title,
    required this.icon,
    required this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: size.width * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
