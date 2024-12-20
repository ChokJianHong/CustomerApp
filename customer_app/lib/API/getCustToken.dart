import 'dart:convert';
import 'package:http/http.dart' as http;

const baseUrl = "http://82.112.238.13:5005";

class CustomerToken {
  Future<Map<String, dynamic>> getCustomerByToken(String token) async {
    final url = Uri.parse('$baseUrl/dashboarddatabase/customer/$token');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      print('Response code: ${response.statusCode}'); // Print response code
      print(
          'Response body: ${response.body}'); // Print response body for debugging

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to get customer details: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (error, stackTrace) {
      print('Error getting customer details: $error\n$stackTrace');
      throw Exception('Error getting customer details: $error');
    }
  }

  Future<Map<String, dynamic>> updateCustomerProfile(
      String token,
      String customerId,
      String name,
      String email,
      String location,
      String alarmBrand,
      String autogateBrand,
      String phoneNumber,
      String alarmWarranty,
      String autogateWarranty) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/dashboarddatabase/admin/customers/$customerId'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': token,
            },
            body: jsonEncode({
              'name': name,
              'email': email,
              'location': location,
              'alarm_brand': alarmBrand,
              'autogate_brand': autogateBrand,
              'phone_number': phoneNumber,
              'alarm_warranty': alarmWarranty,
              'auto_gate_warranty': autogateWarranty,
            }),
          )
          .timeout(const Duration(seconds: 10));

      print('Response status: ${response.statusCode} ');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update customer: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error updating customer: $error');
      throw Exception('Error updating customer: $error');
    }
  }
}
