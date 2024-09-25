import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterAPI {
  static const String baseUrl =
      "http://10.0.2.2:5005"; // Localhost for Android Emulator

  Future<Map<String, dynamic>> registerCustomer(String email, String password,
      String name, String phoneNumber, String location) async {
    try {
      final response = await http.post(
        Uri.parse(
            '$baseUrl/dashboarddatabase/customer/register'), // Assuming your Node.js register route is '/register'
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'name': name,
          'phone_number': phoneNumber,
          'location': location,
        }),
      );

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

  Future<Map<String, dynamic>> registerCustomerBrands(String alarmBrand,
      DateTime? alarmWarranty, String gateBrand, DateTime? gateWarranty) async {
    try {
      final response = await http.post(
        Uri.parse(
            '$baseUrl/dashboarddatabase/customer/register'), // Assuming your Node.js register route is '/register'
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'alarm_brand': alarmBrand,
          'alarm_warranty': alarmWarranty
              ?.toIso8601String(), // Convert DateTime to ISO 8601 string
          'auto_gate_brand': gateBrand,
          'gate_warranty': gateWarranty
              ?.toIso8601String(), // Convert DateTime to ISO 8601 string
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 400) {
        throw Exception("Error");
      } else {
        throw Exception("Failed to register: ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception('Error during registration: $e');
    }
  }
}
