import 'dart:convert';
import 'package:http/http.dart' as http;

const baseUrl = "http://82.112.238.13:5005";

class ReviewApi {
  Future<Map<String, dynamic>> createReview({
    required String token,
    required String orderId,
    required int rating,
    String reviewText = "", // Make reviewText optional (default empty string)
  }) async {
    final url = Uri.parse('$baseUrl/dashboarddatabase/orders/$orderId');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token,
        },
        body: jsonEncode({
          'rating': rating,
          'reviewText': reviewText.isEmpty
              ? null
              : reviewText, // Send null if reviewText is empty
        }),
      );

      // Log status and response for debugging
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        return {
          'success': true,
          'message': responseData['message'],
        };
      } else {
        // Attempt to decode the error message if possible
        try {
          var errorData = jsonDecode(response.body);
          return {
            'success': false,
            'message': errorData['message'] ?? 'Unknown error occurred',
          };
        } catch (e) {
          return {
            'success': false,
            'message': 'Error: Unable to process error response',
          };
        }
      }
    } catch (error) {
      print('Error: $error');
      return {
        'success': false,
        'message': 'Network or server error: $error',
      };
    }
  }
}
