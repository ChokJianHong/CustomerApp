import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:customer_app/core/configs/theme/app_colors.dart';
import 'package:customer_app/pages/homePage.dart';
import 'package:customer_app/pages/orderPage.dart'; // Ensure this is the correct import
import 'package:customer_app/pages/RequisitionForm.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final Function(int) onTap;
  final int currentIndex;
  final String token;

  const BottomNav({
    super.key,
    required this.onTap,
    required this.currentIndex,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: currentIndex,
      backgroundColor: Colors.transparent,
      color: AppColors.secondary,
      buttonBackgroundColor: AppColors.primary,
      height: 60.0,
      onTap: (index) {
        _navigateToPage(context, index, token); // Pass token here
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
        ),
      ],
    );
  }
}

// Update the navigation function to accept the token
void _navigateToPage(BuildContext context, int index, String token) {
  switch (index) {
    case 0:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RequisitionForm(token: token,)),
      );
      break;
    case 1:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(token: token,)),
      );
      break;
    case 2:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrdersPage(token: token), // Pass token correctly
        ),
      );
      break;
    default:
      // Handle default case if necessary
      break;
  }
}
