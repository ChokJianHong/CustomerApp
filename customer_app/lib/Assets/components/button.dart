import 'package:customer_app/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

/* 

BUTTON

A simple button.

--------------------------------------------------------------------------------

To use this widget, you need:

- text
- a function ( on tap )


*/

class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final Color? backgroundColor;

  const MyButton({
    super.key,
    required this.text,
    required this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
