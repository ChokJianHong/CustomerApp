import 'package:customer_app/API/cancelOrder.dart';
import 'package:customer_app/API/getOrderDetails.dart';
import 'package:customer_app/Assets/components/AppBar.dart';
import 'package:customer_app/Assets/components/BottomNav.dart';
import 'package:customer_app/Assets/components/Divider.dart';
import 'package:customer_app/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class RequestDetails extends StatefulWidget {
  final String token;
  final String orderId;

  const RequestDetails({super.key, required this.token, required this.orderId});

  @override
  State<RequestDetails> createState() => _RequestDetailsState();
}

class _RequestDetailsState extends State<RequestDetails> {
  int _currentIndex = 2;
  late Future<Map<String, dynamic>> _orderDetailFuture;

  void _onTapTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _orderDetailFuture =
        _fetchOrderDetails(widget.token, widget.orderId); // Fetch data on init
  }

  Future<Map<String, dynamic>> _fetchOrderDetails(
      String token, String orderId) async {
    try {
      final orderDetails = await OrderDetails().getOrderDetail(token, orderId);
      if (orderDetails['success']) {
        return orderDetails; // Return the entire response
      } else {
        if (mounted) {
          _showErrorDialog(orderDetails['error']);
        }
        throw Exception('Failed to fetch order details');
      }
    } catch (error) {
      if (mounted) {
        _showErrorDialog('Error fetching order details: $error');
      }
      throw Exception('Failed to fetch order details');
    }
  }

  Future<void> _cancelOrder() async {
    try {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(child: CircularProgressIndicator());
          },
        );
      }

      final response = await GetCancelOrder().cancelOrder(
        widget.token,
        widget.orderId,
        'Customer cancelled the order',
      );

      if (mounted) Navigator.of(context).pop();

      if (response['status'] == 200 || response['success'] == true) {
        if (mounted) _showSuccessDialog('Order cancelled successfully');
      } else {
        if (mounted) {
          _showErrorDialog(response['message'] ?? 'Failed to cancel order.');
        }
      }
    } catch (error) {
      if (mounted) Navigator.of(context).pop();
      if (mounted) {
        _showErrorDialog('Error cancelling order: $error');
      }
    }
  }

  void _showErrorDialog(String errorMessage) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _showSuccessDialog(String message) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // Go back to the previous screen
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: CustomAppBar(
        token: widget.token,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _orderDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator()); // Show a loading indicator
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final orderDetails =
                snapshot.data!['result']; // Access the result map

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Problem Type: ${orderDetails['ProblemType'] ?? 'Not provided'}"),
                      const SizedBox(height: 20),
                      Text("Date and Time: ${orderDetails['orderDate']}"),
                      const SizedBox(height: 20),
                      Text("Priority: ${orderDetails['priority']}"),
                      const SizedBox(height: 20),
                      const Text("Problem Description"),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            maxLines: null, // Allow multiple lines
                            decoration: InputDecoration(
                              hintText: '${orderDetails['orderDetail']}',
                              border: InputBorder.none, // Remove border
                            ),
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text(
                                  "Picture: ${orderDetails['orderImage']}")),
                          const Text("View"),
                        ],
                      ),
                      const ADivider(),
                      Text(
                          "Technician: ${orderDetails['technicianName'] ?? 'Not provided'}"),
                      const SizedBox(height: 10),
                      Text(
                          "Estimated Time: ${orderDetails['estimatedTime'] ?? 'Not provided'}"),
                      const SizedBox(height: 10),
                      Text(
                          "Contact Number: ${orderDetails['contactNumber'] ?? 'Not provided'}"),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
      bottomNavigationBar: BottomNav(
        onTap: _onTapTapped,
        currentIndex: _currentIndex,
        token: widget.token,
      ),
    );
  }
}
