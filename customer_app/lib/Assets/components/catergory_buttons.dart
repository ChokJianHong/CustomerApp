import 'package:customer_app/core/configs/theme/app_colors.dart';
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
        // Use Expanded to ensure dynamic width and equal distribution
        Expanded(
          child: categoryButton(
            label: 'Alarm System',
            imagePath: 'lib/Assets/photos/Alarm.png',
            isSelected: isAlarmSelected,
            onTap: () => onSelectCategory('Alarm'),
          ),
        ),
        const SizedBox(width: 10), // Add space between buttons
        Expanded(
          child: categoryButton(
            label: 'AutoGate System',
            imagePath: 'lib/Assets/photos/Autogate.png',
            isSelected: isAutogateSelected,
            onTap: () => onSelectCategory('Autogate'),
          ),
        ),
      ],
    );
  }
}

// This is your category button with the animation
Widget categoryButton({
  required String label,
  required String imagePath,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300), // Animation duration
      curve: Curves.easeInOut, // Smooth animation curve
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.secondary : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isSelected
            ? [const BoxShadow(color: AppColors.secondary, blurRadius: 10)]
            : [],
        border: Border.all(
          color: isSelected ? Colors.blueAccent : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // Ensures the button adjusts dynamically
        children: [
          Image.asset(imagePath, width: 50, height: 50),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center, // Ensure text is centered
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}
