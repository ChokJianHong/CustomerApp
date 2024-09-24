import 'dart:convert';
import 'package:http/http.dart' as http;

const baseUrl = "http://10.0.2.2:5005";

class GetCustomerID{
  Future<Map<String, dynamic>> getCustomerByToken(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/dashboarddatabase/customer/$token'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to get customer details: ${response.reasonPhrase}');
      }
    } catch (error, stackTrace) {
      print('Error getting customer details: $error\n$stackTrace');
      throw Exception('Error getting customer details: $error');
    }
  }
}