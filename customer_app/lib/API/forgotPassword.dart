import 'dart:convert';
import 'package:http/http.dart' as http;

class ForgotPasswordService {
  // Default backend API URL
  static const String apiUrl =
      'http://82.112.238.13:5005/dashboarddatabase/forgot-password';

  Future<Map<String, dynamic>> forgotPassword(
      String email, String userType) async {
    try {
      // Create the payload to send in the request body
      final Map<String, dynamic> requestBody = {
        'email': email,
        'userType': userType,
      };

      // Send the POST request
      final response = await http.post(
        Uri.parse(apiUrl), // Use the default URL for forgot-password
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(requestBody),
      );

      // Handle the response
      if (response.statusCode == 200) {
        return json.decode(response.body); // Success: return the response body
      } else {
        throw Exception('Failed to send password reset link');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}
