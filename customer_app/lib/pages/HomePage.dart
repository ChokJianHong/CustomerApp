import 'package:customer_app/Assets/components/AppBar.dart';
import 'package:customer_app/Assets/components/BottomNav.dart';
import 'package:customer_app/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1;

  void _onTapTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: const CustomAppBar(),
      bottomNavigationBar: BottomNav(onTap: _onTapTapped, currentIndex: _currentIndex),
    );
  }
}