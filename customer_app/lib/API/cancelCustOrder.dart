import 'dart:convert';
import 'package:http/http.dart' as http;

const baseUrl = "http://82.112.238.13:5005";

class GetCancelOrder {
  // Function to cancel the order by sending a PUT request
  Future<Map<String, dynamic>> cancelOrder(String token, String orderId) async {
    final url = Uri.parse('$baseUrl/dashboarddatabase/orders/cancel/$orderId');

    try {
      // Sending the PUT request with the token in the headers
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token, // Add authorization token to header
        },
      ).timeout(const Duration(seconds: 10)); // Timeout after 10 seconds

      // Debugging logs to inspect the response
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Handling different HTTP status codes
      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Return decoded response on success
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid token.');
      } else if (response.statusCode == 404) {
        throw Exception('Order not found: Invalid order ID.');
      } else {
        throw Exception(
            'Failed to cancel order: ${response.reasonPhrase}. Body: ${response.body}');
      }
    } catch (error) {
      // Error handling in case of network or other issues
      print('Error cancelling order: $error');
      throw Exception('Error cancelling order: $error');
    }
  }
}
