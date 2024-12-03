import 'dart:convert';
import 'package:http/http.dart' as http;

const baseUrl = "http://82.112.238.13:5005";

class BannerService {
  // Fetch banners without using a model class
  static Future<List<Map<String, dynamic>>> fetchBanners(String token) async {
    final url = Uri.parse('$baseUrl/dashboarddatabase/admin/banner');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token,
          'userType': 'customer'
        },
      );

      // Print the response body
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Decode the response body directly into a List of Maps
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> bannerJson = responseData['data'];

        return List<Map<String, dynamic>>.from(bannerJson);
      } else {
        throw Exception('Failed to load banners: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching banners: $e');
    }
  }
}
