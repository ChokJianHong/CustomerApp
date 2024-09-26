import 'dart:convert';
import 'package:customer_app/Assets/Model/OrderModel.dart';
import 'package:http/http.dart' as http;


const baseUrl = "http://10.0.2.2:5005";

class CustomerOrder {
  Future<List<OrderModel>> getCustomerOrders(
      String token, String customerId) async {
    try {
      print('Fetching orders for customer ID: $customerId with token: $token');
      final response = await http.get(
        Uri.parse('$baseUrl/dashboarddatabase/orders'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token,
          'userType': 'customer'
        },
      ).timeout(const Duration(seconds: 10));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print("Customer ID: $customerId");

      if (response.statusCode == 200) {
        List<dynamic> ordersJson = jsonDecode(response.body)['result'];
        return ordersJson.map((json) => OrderModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch orders: ${response.reasonPhrase}');
      }
    } catch (error, stackTrace) {
      print('Error fetching orders: $error\n$stackTrace');
      throw Exception('Error fetching orders: $error');
    }
  }
}
