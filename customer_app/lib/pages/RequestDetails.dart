import 'package:customer_app/Assets/components/AppBar.dart';
import 'package:customer_app/Assets/components/BottomNav.dart';
import 'package:customer_app/Assets/components/Divider.dart';
import 'package:customer_app/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class RequestDetails extends StatefulWidget {
  const RequestDetails({super.key});

  @override
  State<RequestDetails> createState() => _RequestDetailsState();
}

class _RequestDetailsState extends State<RequestDetails> {
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
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Problem Type: Auto Gate"),
                const SizedBox(
                  height: 20,
                ),
                const Text("Date and Time: 2024-6-5 3:00 P.M."),
                const SizedBox(
                  height: 20,
                ),
                const Text("Priority: Urgent"),
                const SizedBox(
                  height: 20,
                ),
                const Text("Problem Description"),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Padding(
                    padding:
                        EdgeInsets.all(8.0), // Add padding inside the container
                    child: TextField(
                      maxLines: null, // Allow multiple lines
                      decoration: InputDecoration(
                        border:
                            InputBorder.none, // Remove border of the TextField
                      ),
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Picture Auto Gate.PNG"),
                    Text("View"),
                  ],
                ),
                const ADivider(),
                Text("Technician: Dylan"),
                SizedBox(
                  height: 10,
                ),
                Text("Estimated Time: 1:55 P.M. - 2:15 P.M."),
                SizedBox(
                  height: 10,
                ),
                Text("Contact Number: +6012-3456789"),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar:
          BottomNav(onTap: _onTapTapped, currentIndex: _currentIndex),
    );
  }
}
