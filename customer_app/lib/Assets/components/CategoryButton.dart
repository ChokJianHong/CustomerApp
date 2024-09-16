import 'package:customer_app/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class categoryButton extends StatelessWidget {
  final String label;
  final IconData? icon;  // Make this optional to allow images too
  final String? imagePath; // Add an optional image path
  final bool isSelected;
  final Function() onTap;

  const categoryButton({
    super.key,
    required this.label,
    this.icon,          // Icon is optional now
    this.imagePath, 
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : AppColors.primary, // Purple when not selected, white when selected
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.blue, // Blue outline
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20,),
            // Display Icon or Image
            if (icon != null)
              Icon(
                icon,
                size: 50,
                color: isSelected ? AppColors.primary: Colors.white, // Color change based on selection
              )
            else if (imagePath != null)
              Image.asset(
                imagePath!,
                width: 60,
                height: 60,
                color: isSelected ? AppColors.primary : Colors.white, // Color change based on selection
              ),
            const SizedBox(height: 10),
            // Label inside a blue container
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,  // Full width label container
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: const BoxDecoration(
                    color: AppColors.blue,  // Blue background for the label
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,  // White text
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}