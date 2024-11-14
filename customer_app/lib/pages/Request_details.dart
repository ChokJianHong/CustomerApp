import 'package:customer_app/API/cancelCustOrder.dart';
import 'package:customer_app/API/getOrderDetails.dart';
import 'package:customer_app/API/get_technician.dart';
import 'package:customer_app/Assets/components/Divider.dart';
import 'package:customer_app/Assets/components/textbox.dart';
import 'package:customer_app/core/app_colors.dart';
import 'package:customer_app/pages/home.dart';
import 'package:customer_app/pages/messages.dart';
import 'package:customer_app/pages/messages1.dart';
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
  late Future<Map<String, dynamic>> _orderDetailFuture;
  Future<Map<String, dynamic>>? _technicianDetailFuture;

  @override
  void initState() {
    super.initState();
    _orderDetailFuture = _fetchOrderDetails(widget.token, widget.orderId);
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
        return orderDetails;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(token: widget.token)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _orderDetailFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final orderDetails = snapshot.data!['result'];
              final technicianId = orderDetails['TechnicianID'].toString();
              final customerId = orderDetails['CustomerID'].toString();

              _technicianDetailFuture ??= _fetchTechnicianDetails(technicianId);

              String brand = 'Unknown brand';
              String warranty = 'Warranty not available';
              if (orderDetails['ProblemType'] == 'autogate') {
                brand = orderDetails['customer']['autogateBrand'] ??
                    'Unknown Brand';
                warranty = orderDetails['customer']['autogateWarranty'] ??
                    'No warranty';
              } else if (orderDetails['ProblemType'] == 'alarm') {
                brand =
                    orderDetails['customer']['alarmBrand'] ?? 'Unknown Brand';
                warranty =
                    orderDetails['customer']['alarmWarranty'] ?? 'No warranty';
              }

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (orderDetails['orderImage'] != null)
                          Flexible(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  15.0), // Set the border radius
                              child: Image.network(
                                'http://82.112.238.13:5005/${orderDetails['orderImage']}?timestamp=${DateTime.now().millisecondsSinceEpoch}',
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Text("Image not available");
                                },
                              ),
                            ),
                          )
                        else
                          const Text("No Image Available"),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Address',
                            style: TextStyle(
                                color: AppColors.darkGreen,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            orderDetails['locationDetail'] ?? 'Not provided',
                            style: const TextStyle(
                                color: AppColors.lightgrey, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Brand',
                                    style: TextStyle(
                                        color: AppColors.darkGreen,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    brand,
                                    style: const TextStyle(
                                      color: AppColors.lightgrey,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Date',
                                    style: TextStyle(
                                        color: AppColors.darkGreen,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    formatDateTime(orderDetails['orderDate']),
                                    style: const TextStyle(
                                      color: AppColors.lightgrey,
                                      fontSize: 15,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 100,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Warranty',
                                    style: TextStyle(
                                        color: AppColors.darkGreen,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    formatDateTime(warranty),
                                    style: const TextStyle(
                                      color: AppColors.lightgrey,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Time',
                                    style: TextStyle(
                                        color: AppColors.darkGreen,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    orderDetails['orderTime'],
                                    style: const TextStyle(
                                      color: AppColors.lightgrey,
                                      fontSize: 15,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Problem Description",
                            style: TextStyle(
                                fontSize: 20, color: AppColors.darkGreen),
                          ),
                          Text(
                            orderDetails['orderDetail'],
                            style: const TextStyle(
                                color: AppColors.lightgrey, fontSize: 15),
                          ),
                          const SizedBox(height: 20),
                          const ADivider(),
                          const SizedBox(height: 10),
                          Placeholder(
                            fallbackHeight: 200.0,
                            fallbackWidth: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Display image from the constructed URL
                                if (orderDetails['orderDoneImage'] != null)
                                  Image.network(
                                    'http://82.112.238.13:5005/${orderDetails['orderDoneImage']}',
                                    width: 200,
                                    height: 200,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Text("Image not available");
                                    },
                                  )
                                else
                                  const Text(
                                      "Currently Not Complete"), // Placeholder text if no image URL

                                // Expanded widget for text and button
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          FutureBuilder<Map<String, dynamic>>(
                            future: _technicianDetailFuture,
                            builder: (context, techSnapshot) {
                              if (techSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (techSnapshot.hasError) {
                                return Text('Error: ${techSnapshot.error}');
                              } else if (techSnapshot.hasData) {
                                final technicianList =
                                    techSnapshot.data!['technician'] ?? [];

                                if (technicianList.isNotEmpty) {
                                  final technicianDetails = technicianList[0];
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10),
                                      const Text(
                                        'Technician',
                                        style: TextStyle(
                                            color: AppColors.darkGreen,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        technicianDetails['name'] ??
                                            'Not provided',
                                        style: const TextStyle(
                                          color: AppColors.lightgrey,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        'Estimated',
                                        style: TextStyle(
                                            color: AppColors.darkGreen,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        formatDateTime(
                                            orderDetails['TechnicianETA'] ??
                                                'No ETA available'),
                                        style: const TextStyle(
                                          color: AppColors.lightgrey,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        'Contact Number',
                                        style: TextStyle(
                                            color: AppColors.darkGreen,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        technicianDetails['phone_number'] ??
                                            'Not provided',
                                        style: const TextStyle(
                                          color: AppColors.lightgrey,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  );
                                } else {
                                  return const Text('Request is still Pending');
                                }
                              } else {
                                return const Text(
                                    'No technician details available');
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    MyButton(
                      text: 'Go Back Home',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(token: widget.token),
                          ),
                        );
                      },
                    ),
                    // Add this ElevatedButton below MyButton
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.blue, // Set button color if needed
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                      onPressed: () {
                        // Replace these with actual values
                        String currentUserId =
                            customerId; // Or retrieve it from the order or user context
                        String chatPartnerId = widget
                            .orderId; // Or the technician's ID or another identifier

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              currentUserId: currentUserId,
                              chatPartnerId: chatPartnerId,
                              token: widget.token,
                            ),
                          ),
                        );
                      },
                      child: const Text('Go to Messages'),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }
}
