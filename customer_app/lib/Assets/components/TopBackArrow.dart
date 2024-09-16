import 'package:customer_app/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BackArrow extends StatelessWidget {
  final void Function()? onTap;
  const BackArrow({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary, // Match app bar color with background
      elevation: 0, // Remove shadow
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ), // Back arrow icon
        onPressed: () {
          onTap;
        },
      ),
    );
  }
}
