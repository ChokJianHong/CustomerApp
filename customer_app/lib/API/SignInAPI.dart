import 'dart:convert';
import 'dart:async'; // For handling timeouts
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

const baseUrl = "http://82.112.238.13:5005"; // Adjust if needed

class SignInAPI {
  final storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/dashboarddatabase/login'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            },
            // Encode the body so that the program recognizes it is a JSON file
            body: jsonEncode({
              'email': email,
              'password': password,
              'userType': 'customer',
            }),
          )
          .timeout(const Duration(seconds: 20)); // Add a timeout of 20 seconds

      if (response.statusCode == 200) {
        // Parse the JSON response body to a Dart object
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Assuming the response contains the token in `token` key
        final String token = data['token'];

        // Store the token securely
        await storage.write(key: 'jwt_token', value: token);

        // Return the response data (including token)
        return data;
      } else {
        throw Exception('Failed to log in: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error logging in: $error');
    }
  }

  Future<http.Response> fetchUserData() async {
    // Retrieve the JWT token from secure storage
    final String? token = await storage.read(key: 'jwt_token');

    if (token == null) {
      throw Exception('User is not authenticated');
    }

    // Use the token in the authorization header for the API request
    final response = await http.get(
      Uri.parse(
          '$baseUrl/protected-route'), // Replace with your actual endpoint
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Handle successful response
      return response;
    } else {
      throw Exception('Failed to load user data');
    }
  }
}
