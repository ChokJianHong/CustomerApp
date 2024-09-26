import 'package:flutter/material.dart';

class EmergencyLevelButtons extends StatelessWidget {
  const EmergencyLevelButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> levels = ['STANDARD', 'URGENT', 'EMERGENCY'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: levels.map((level) {
        return ElevatedButton(
          onPressed: () => _handleEmergencyLevel(level),
          child: Text(level),
        );
      }).toList(),
    );
  }

  void _handleEmergencyLevel(String level) {
    // You can handle selection logic here
  }
}
