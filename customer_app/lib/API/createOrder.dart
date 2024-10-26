import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderAPI {
  static const String baseUrl =
      "http://10.0.2.2:5005"; // Localhost for Android Emulator

  static Future<Map<String, dynamic>> createOrder({
    required String token,
    required Map<String, dynamic> orderData,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/dashboarddatabase/orders'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token,
          'userType': 'customer'
        },
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'message': 'success'};
      } else {
        return {'success': false, 'message': 'Failed to create order'};
      }
    } catch (err) {
      return {'success': false, 'message': 'Error: $err'};
    }
  }
}
