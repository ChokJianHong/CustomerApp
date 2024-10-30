import 'package:customer_app/core/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileAttribute extends StatefulWidget {
  final String title;
  final VoidCallback? onTap;
  final TextEditingController controller; // Accept controller as a parameter

  const ProfileAttribute({
    super.key,
    required this.title,
    this.onTap,
    required this.controller, // Make controller required
  });

  @override
  State<ProfileAttribute> createState() => _ProfileAttributeState();
}

class _ProfileAttributeState extends State<ProfileAttribute> {
  bool _isExpanded = false; // Track if the tile is expanded

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.deeppurple,
      child: ExpansionTile(
        title: Text(
          widget.title,
          style: const TextStyle(color: AppColors.lightgrey, fontSize: 18),
        ),
        trailing: Icon(
          _isExpanded
              ? Icons.arrow_drop_down_circle
              : Icons.arrow_drop_down, // Use different icons
          color: Colors.white,
        ),
        iconColor: Colors.white, // Set the color of the arrow icon
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
        onExpansionChanged: (bool expanded) {
          setState(() {
            _isExpanded = expanded;
          });
          if (widget.onTap != null && expanded) {
            widget.onTap!(); // Trigger the onTap if provided when expanded
          }
        },
        children: _isExpanded
            ? [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: widget.controller, // Use the passed controller
                    decoration: InputDecoration(
                      hintText: "Enter ${widget.title}",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ]
            : [],
      ),
    );
  }
}
