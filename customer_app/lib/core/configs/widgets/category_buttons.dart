import 'package:customer_app/Assets/components/CategoryButton.dart';
import 'package:flutter/material.dart';

class CategoryButtons extends StatelessWidget {
  final bool isAlarmSelected;
  final bool isAutogateSelected;
  final Function(String) onSelectCategory;

  const CategoryButtons({
    required this.isAlarmSelected,
    required this.isAutogateSelected,
    required this.onSelectCategory,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        categoryButton(
          label: 'Alarm System',
          imagePath: 'lib/Assets/photos/Alarm.png',
          isSelected: isAlarmSelected,
          onTap: () => onSelectCategory('Alarm'),
        ),
        categoryButton(
          label: 'AutoGate System',
          imagePath: 'lib/Assets/photos/Autogate.png',
          isSelected: isAutogateSelected,
          onTap: () => onSelectCategory('Autogate'),
        ),
      ],
    );
  }
}
