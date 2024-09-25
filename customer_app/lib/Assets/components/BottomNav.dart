import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:customer_app/core/configs/theme/app_colors.dart';
import 'package:customer_app/pages/HomePage.dart';
import 'package:customer_app/pages/OrderPage.dart';
import 'package:customer_app/pages/RequisitionForm.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final Function(int) onTap;
  final int currentIndex;

  const BottomNav({super.key, required this.onTap, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: currentIndex,
      backgroundColor: Colors.transparent, // Transparent background
      color: AppColors.secondary, // Background color of the bar
      buttonBackgroundColor: AppColors.primary, // Color of the central button
      height: 60.0, // Adjusted height for better icon size
      onTap: (index) {
        _navigateToPage(context, index);
      },
      items: const [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Icon(
            Icons.favorite,
            color: Colors.white,
            size: 40,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Icon(
            Icons.home,
            color: Colors.white,
            size: 40,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Icon(
            Icons.settings,
            color: Colors.white,
            size: 40,
          ),
        )
      ],
    );
  }
}

//Help bottomnav navigate to pages
void _navigateToPage(BuildContext context, int index) {
  switch (index) {
    case 0:
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RequisitionForm()),
      );
      break;
    case 1:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
      break;
    case 2:
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OrdersPage()),
      );
      break;
    default:
      // Handle default case
      break;
  }
}
