import 'package:customer_app/API/getCustOrder.dart';
import 'package:customer_app/Assets/components/AppBar.dart';
import 'package:customer_app/assets/components/navbar.dart';
import 'package:customer_app/assets/components/newjobcard.dart';
import 'package:customer_app/assets/models/OrderModel.dart';
import 'package:customer_app/core/app_colors.dart';
import 'package:customer_app/pages/Request_details.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class OrdersPage extends StatefulWidget {
  final String token;

  const OrdersPage({super.key, required this.token});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late Future<List<OrderModel>> _ordersFuture;
  late String customerId;
  int _currentIndex = 2;

  // Added variable for dropdown filter
  String? _selectedStatus;
  final List<String> _statusOptions = [
    'All',
    'Pending',
    'OnGoing',
    'Completed',
    'Cancelled'
  ]; // Add more statuses as needed

  void _onTapTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Decode the token to extract customer ID
    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(widget.token);
      customerId = decodedToken['customer_id'];
    } catch (error) {
      print('Error decoding token: $error');
      customerId = 'default';
    }

    // Load orders initially without filter
    _ordersFuture = _fetchOrders();
  }

  // Function to fetch orders based on the selected filter
  Future<List<OrderModel>> _fetchOrders() async {
    final orders = await CustomerOrder()
        .getCustomerOrders(widget.token, customerId, status: _selectedStatus);

    // Sort orders by date in descending order (newest first)
    orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
    return orders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        token: widget.token,
      ),
      backgroundColor: AppColors.primary,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown Filter
            DropdownButton<String>(
              hint: const Text(
                'Select Order Status',
                style: TextStyle(color: Colors.white),
              ),
              value: _selectedStatus,
              items: _statusOptions.map((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(
                    status,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedStatus = newValue;
                  _ordersFuture =
                      _fetchOrders(); // Re-fetch orders based on selected filter
                });
              },
              dropdownColor: AppColors.secondary,
            ),
            const SizedBox(
                height: 16), // Add some space between dropdown and list
            Expanded(
              child: FutureBuilder<List<OrderModel>>(
                future: _ordersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    final orders = snapshot.data!;
                    return ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
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
                          child: NewJobcard(
                              name: order.problemType,
                              location: order.locationDetails,
                              jobType: order.urgencyLevel,
                              status: order.orderStatus),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No orders available'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        onTap: _onTapTapped,
        currentIndex: _currentIndex,
        token: widget.token,
      ),
    );
  }
}
