import 'dart:convert';
import 'package:http/http.dart' as http;

const baseUrl = "http://10.0.2.2:5005";

class SignInAPI{
  
    Future<Map<String, dynamic>> SignInUser(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/dashboarddatabase/login'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              'email': email,
              'password': password,
              'userType': 'customer',
            }),
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('userId')) {
          return data;
        } else {
          throw Exception('User ID not found in response');
        }
      } else {
        throw Exception('Failed to sign in: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error signing in: $error');
    }
  }
}
