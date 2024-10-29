import 'package:customer_app/API/cancelCustOrder.dart';
import 'package:customer_app/API/getOrderDetails.dart';
import 'package:customer_app/API/get_technician.dart';
import 'package:customer_app/Assets/components/Divider.dart';
import 'package:customer_app/assets/components/appbar.dart';
import 'package:customer_app/assets/components/navbar.dart';
import 'package:customer_app/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  Future<Map<String, dynamic>>? _technicianDetailFuture; // Change to nullable

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

  String formatDateTime(String utcDateTime) {
    try {
      DateTime parsedDate = DateTime.parse(utcDateTime);
      DateTime localDate = parsedDate.toLocal();
      return DateFormat('yyyy-MM-dd').format(localDate);
    } catch (e) {
      print('Error parsing date: $e');
      return 'Invalid date';
    }
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

  Future<Map<String, dynamic>> _fetchTechnicianDetails(
      String technicianId) async {
    try {
      return await TechnicianService.getTechnician(widget.token, technicianId);
    } catch (error) {
      if (mounted) {
        _showErrorDialog('Error fetching technician details: $error');
      }
      throw Exception('Failed to fetch technician details');
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
            title: const Text('Error'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
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
            title: const Text('Success'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // Go back to the previous screen
                },
                child: const Text('OK'),
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

            // Get technician ID from order details
            final technicianId =
                orderDetails['TechnicianID'].toString(); // Convert to String

            // Fetch technician details if not already fetched
            _technicianDetailFuture ??= _fetchTechnicianDetails(technicianId);

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
                      Text(
                          "Date and Time: ${formatDateTime(orderDetails['orderDate'])} ${orderDetails['orderTime']}"),
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
                          border: Border.all(
                              color: Colors.grey,
                              width: 1), // Add border color and width
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            maxLines: null, // Allow multiple lines
                            decoration: InputDecoration(
                              hintText: '${orderDetails['orderDetail']}',
                              border:
                                  InputBorder.none, // Remove TextField border
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
                      const SizedBox(height: 10),
                      FutureBuilder<Map<String, dynamic>>(
                        future: _technicianDetailFuture,
                        builder: (context, techSnapshot) {
                          if (techSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator(); // Loading indicator for technician details
                          } else if (techSnapshot.hasError) {
                            return Text('Error: ${techSnapshot.error}');
                          } else if (techSnapshot.hasData) {
                            final technicianDetails =
                                techSnapshot.data!['technician']
                                    [0]; // Access the first technician
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                    "Technician: ${technicianDetails['name'] ?? 'Not provided'}"),
                                const SizedBox(height: 10),
                                Text(
                                    "Estimated Time: ${orderDetails['TechnicianETA'] ?? 'Not provided'}"),
                                const SizedBox(height: 10),
                                Text(
                                    "Contact Number: ${technicianDetails['phone_number'] ?? 'Not provided'}"),
                                const SizedBox(height: 10),
                              ],
                            ); // Display technician name and phone number
                          } else {
                            return const Text(
                                'No technician details available');
                          }
                        },
                      ),
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
