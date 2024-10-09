import 'dart:convert';
import 'package:http/http.dart' as http;

const baseUrl = "http://10.0.2.2:5005";

class GetCancelOrder {
  Future<Map<String, dynamic>> cancelOrder(
      String token, String orderId, String cancelDetails) async {
    final url = Uri.parse('$baseUrl/dashboarddatabase/orders/cancel/$orderId');

    try {
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': token,
            },
            body: jsonEncode({
              'cancel_details': cancelDetails,
            }),
          )
          .timeout(const Duration(seconds: 10));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to cancel order: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error cancelling order: $error');
      throw Exception('Error cancelling order: $error');
    }
  }
}
