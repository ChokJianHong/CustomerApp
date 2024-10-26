import 'package:customer_app/API/getCustOrder.dart';
import 'package:customer_app/assets/components/appbar.dart';
import 'package:customer_app/assets/components/jobcard.dart';
import 'package:customer_app/assets/components/navbar.dart';
import 'package:customer_app/assets/models/OrderModel.dart';
import 'package:customer_app/core/app_colors.dart';
import 'package:customer_app/pages/Request_details.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final String token;

  const HomePage({super.key, required this.token});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1;
  final CustomerOrder customerOrder =
      CustomerOrder(); // Instantiate the service
  late String customerId;
  late Future<List<OrderModel>> _latestOrderFuture;

  void _onTapTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  String formatDateTime(String utcDateTime) {
    try {
      // Parse the UTC date string into a DateTime object
      DateTime parsedDate = DateTime.parse(utcDateTime);

      // Convert the UTC date to local time
      DateTime localDate = parsedDate.toLocal();

      // Format the local date into a desired string format
      return DateFormat('yyyy-MM-dd HH:mm:ss')
          .format(localDate); // Adjust format as needed
    } catch (e) {
      // Handle potential parsing errors
      print('Error parsing date: $e');
      return 'Invalid date'; // Return a default value or error message
    }
  }

  @override
  void initState() {
    super.initState();
    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(widget.token);
      customerId = decodedToken['userId'].toString(); // Adjust key as needed
      print('Customer ID: $customerId');
    } catch (error) {
      print('Error decoding token: $error');
      customerId = 'default'; // Set a default value
    }

    // Fetch orders using the customer ID
    _latestOrderFuture = customerId.isNotEmpty
        ? customerOrder.getCustomerOrders(widget.token, customerId)
        : Future.value([]); // Initialize with empty list
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get screen size
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: CustomAppBar(
        token: widget.token,
      ),
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
                      'lib/assets/images/banner.png',
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          FutureBuilder<List<OrderModel>>(
            future: _latestOrderFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                final List<OrderModel> latestOrders = snapshot.data!;
                final ongoingOrders = latestOrders
                    .where((order) => order.orderStatus == 'ongoing')
                    .toList();

                if (ongoingOrders.isEmpty) {
                  return const Text(
                    'No ongoing orders.',
                    style: TextStyle(color: Colors.white),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: ongoingOrders.length,
                  itemBuilder: (context, index) {
                    final OrderModel order = ongoingOrders[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RequestDetails(
                              orderId: order.orderId.toString(),
                              token: widget.token,
                            ),
                          ),
                        );
                      },
                      child: JobCard(
                          name: order.problemType,
                          description: order.orderDetail,
                          status: order.orderStatus),
                    );
                  },
                );
              }
              return const SizedBox(); // Return an empty box if no data
            },
          ),
        ],
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
