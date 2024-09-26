import 'package:customer_app/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class DateTimeInfo extends StatelessWidget {
  const DateTimeInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date:  17 July 2024',
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              'Time:  4:00 P.M',
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
