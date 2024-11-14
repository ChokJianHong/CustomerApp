import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterAPI {
  static const String baseUrl =
      "http://10.0.2.2:5005"; // Localhost for Android Emulator

  Future<Map<String, dynamic>> registerCustomer(
      String email,
      String password,
      String name,
      String phoneNumber,
      String location,
      String alarmBrand,
      String alarmWarranty,
      String autogateWarranty,
      String gateBrand) async {
    try {
      // Construct the URL
      final url = Uri.parse('$baseUrl/dashboarddatabase/customer/register');

      // Create the request body
      final body = jsonEncode({
        'email': email,
        'password': password,
        'name': name,
        'phone_number': phoneNumber,
        'location': location,
        'alarm_brand': alarmBrand,
        'alarm_warranty': alarmWarranty, // Corrected key here
        'auto_gate_warranty': autogateWarranty,
        'auto_gate_brand': gateBrand,
      });

      // Debugging: print the URL and body
      print('Sending POST request to: $url');
      print('Request body: $body');

      // Make the POST request
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body,
      );

      // Handle response
      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 400) {
        throw Exception("Email already exists.");
      } else {
        throw Exception("Failed to register: ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception('Error during registration: $e');
    }
  }
}
