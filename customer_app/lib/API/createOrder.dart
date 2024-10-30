import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderAPI {
  static const String baseUrl =
      "http://82.112.238.13:5005"; // Localhost for Android Emulator

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
        return {'success': true, 'message': 'Order created successfully'};
      } else {
        return {'success': false, 'message': 'Failed to create order'};
      }
    } catch (err) {
      return {'success': false, 'message': 'Error: $err'};
    }
  }

  Future<String> fetchCustomerLocationFromAPI() async {
    final response = await http.get(Uri.parse(
        'http://82.112.238.13:5005/dashboarddatabase/:id/location')); // Adjust the ID as needed

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      final data = jsonDecode(response.body);
      return data['location']; // Return the location from the response
    } else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to load customer location');
    }
  }
}
