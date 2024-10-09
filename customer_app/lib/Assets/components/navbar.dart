import 'package:customer_app/core/app_colors.dart';
import 'package:customer_app/pages/Requisition.dart';
import 'package:customer_app/pages/home.dart';
import 'package:customer_app/pages/order.dart';
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
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _navigateToPage(context, index, token), // Handle tap
      backgroundColor: Colors.white, // Clean background
      selectedItemColor: AppColors.primary, // Professional highlight color
      unselectedItemColor: Colors.grey, // Subtle unselected color
      showSelectedLabels: true, // Show labels for clarity
      showUnselectedLabels: false, // Hide labels for unselected items
      type: BottomNavigationBarType.fixed, // Ensures all icons are visible
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }

  void _navigateToPage(BuildContext context, int index, String token) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RequisitionForm(token: token),
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(token: token),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OrdersPage(token: token),
          ),
        );
        break;
      default:
        break;
    }
  }
}
