import 'package:customer_app/assets/components/navbar.dart';
import 'package:customer_app/core/app_colors.dart';
import 'package:customer_app/pages/Requisition.dart';
import 'package:customer_app/pages/home.dart';
import 'package:customer_app/pages/order.dart';
import 'package:flutter/material.dart';


class PageViewScreen extends StatefulWidget {
  final String token; // Token to be passed to the pages

  const PageViewScreen({super.key, required this.token});

  @override
  _PageViewScreenState createState() => _PageViewScreenState();
}

class _PageViewScreenState extends State<PageViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page View with BottomNav'),
        backgroundColor: AppColors.darkTeal, // AppBar color
      ),
     
    );
  }
}
