import 'package:customer_app/API/GetCustomerOrder.dart';
import 'package:customer_app/Assets/Model/OrderModel.dart';
import 'package:customer_app/Assets/components/OrderItem.dart';
import 'package:customer_app/Assets/components/TokenProvider.dart';
import 'package:customer_app/pages/RequestDetails.dart';
import 'package:flutter/material.dart';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart'; // If using Provider for token management

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late Future<List<OrderModel>> _ordersFuture;
  late String customerId;

  @override
  void initState() {
    super.initState();
    // Assuming you have a provider for token management
    String token = Provider.of<TokenProvider>(context, listen: false).token; 

    // Decode the token to extract customer ID
    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      customerId = decodedToken['customer_id'];
    } catch (error) {
      print('Error decoding token: $error');
      // Set a default value for customerId
      customerId = 'default'; // You can choose any default value here
    }

    _ordersFuture = customerId.isNotEmpty
        ? CustomerOrder().getCustomerOrders(token, customerId)
        : Future.value([]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: FutureBuilder<List<OrderModel>>(
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
                          
                        ),
                      ),
                    );
                  },
                  child: OrderItem(order: order), // Use the new OrderItem widget
                );
              },
            );
          } else {
            return const Center(child: Text('No orders available'));
          }
        },
      ),
    );
  }
}
