import 'package:customer_app/Assets/components/AppBar.dart';
import 'package:customer_app/Assets/components/BottomNav.dart';
import 'package:flutter/material.dart';

class Requisition extends StatefulWidget {
  const Requisition({super.key});

  @override
  State<Requisition> createState() => _RequisitionState();
}

class _RequisitionState extends State<Requisition> {
  int _currentIndex = 0;

  void _onTapTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Colors.blue,
      bottomNavigationBar: BottomNav(onTap: _onTapTapped, currentIndex: _currentIndex),
    );
    
  }
}