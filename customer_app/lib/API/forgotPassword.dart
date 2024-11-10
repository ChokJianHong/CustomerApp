import 'dart:convert';
import 'package:http/http.dart' as http;

class ForgotPasswordService {
  // URL to your backend API
  static const String apiUrl = 'http://82.112.238.13:5005';

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
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'userType': 'customer',
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
