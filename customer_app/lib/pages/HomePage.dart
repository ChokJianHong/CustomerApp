import 'package:customer_app/Assets/components/AppBar.dart';
import 'package:customer_app/Assets/components/BottomNav.dart';
import 'package:customer_app/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String token;

  const HomePage({super.key, required this.token});

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
    // Use MediaQuery to get screen size
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                  height: size.height * 0.02), // Adjust size proportionally
              _buildServiceHours(size),
              SizedBox(
                  height: size.height * 0.02), // Adjust spacing proportionally
              _buildCurrentOrders(size),
              SizedBox(height: size.height * 0.02),
              Center(
                child: Container(
                  width: size.width * 0.9, // Take 90% of the screen width
                  height:
                      size.height * 0.2, // Limit height to 20% of screen height
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        10), // Optional: Add border radius for styling
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 4), // Shadow position
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        10), // Apply border radius to the image as well
                    child: Image.asset(
                      'lib/Assets/photos/banner.png',
                      fit: BoxFit
                          .contain, // Ensure the entire image fits within the container
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(
        onTap: _onTapTapped,
        currentIndex: _currentIndex,
        token: widget.token,
      ),
    );
  }

  // Build Service Hours Section
  Widget _buildServiceHours(Size size) {
    return Card(
      color: AppColors.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Service Hours',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Dynamically size the columns
                _buildServiceDayColumn(
                  'Monday - Friday',
                  '9:00 A.M. to 5:00 P.M.',
                  size.width / 3,
                ),
                _buildServiceDayColumn(
                  'Saturday - Sunday',
                  '9:00 A.M. to 12:00 P.M.',
                  size.width / 3,
                ),
                _buildServiceDayColumn(
                  'Public Holiday',
                  'OFF',
                  size.width / 3,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Service Day Column Helper
  Widget _buildServiceDayColumn(String day, String time, double width) {
    return Flexible(
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              overflow: TextOverflow.ellipsis, // Prevent overflow
              maxLines: 1, // Limit to one line
            ),
            Text(
              time,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              overflow: TextOverflow.ellipsis, // Prevent overflow
              maxLines: 1, // Limit to one line
            ),
          ],
        ),
      ),
    );
  }

  // Build Current Orders Section
  Widget _buildCurrentOrders(Size size) {
    return Card(
      color: AppColors.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Orders',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Use dynamic height for the ListView
            SizedBox(
              height: size.height * 0.25, // Adjust height as needed
              child: ListView.builder(
                itemCount: 5, // Replace with your orders count
                itemBuilder: (context, index) {
                  return _buildOrderCard(
                    'Auto Gate',
                    'Dylan',
                    '2024-06-12 12:00 P.M.',
                    size,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build Order Card Widget
  Widget _buildOrderCard(
      String service, String person, String dateTime, Size size) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                service,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                person,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          SizedBox(
            width: size.width * 0.4, // Adjust width dynamically for date text
            child: Text(
              dateTime,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
