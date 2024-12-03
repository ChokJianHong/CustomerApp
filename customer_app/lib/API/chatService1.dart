import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class ChatService1 {
  final String baseUrl = "http://10.0.2.2:5005";

  // Send messages
  Future<void> sendMessage(String orderId, String message, String token) async {
    final url = Uri.parse('$baseUrl/dashboarddatabase/chat/sendMessage');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };

    final body = json.encode({
      'orderId': orderId,
      'message': message,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print('Message sent successfully');
      } else {
        print('Failed to send message: ${response.statusCode}');
        throw Exception('Failed to send message');
      }
    } catch (err) {
      print('Error sending message: $err');
      throw Exception('Error sending message');
    }
  }

  // Listen for messages in the specific order chat (orderId)
  Stream<List<Map<String, dynamic>>> listenToMessages(String orderId) {
    return FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId) // Fetching the specific order
        .collection('messages') // Fetching the messages sub-collection
        .orderBy('timestamp',
            descending: true) // Ordering by timestamp to show the latest first
        .snapshots()
        .map((querySnapshot) {
      // Mapping the Firestore snapshot into a list of messages
      return querySnapshot.docs.map((doc) {
        return {
          'senderId': doc['senderId'],
          'message': doc['message'],
          'timestamp': doc['timestamp'], // Timestamp can be used for ordering
        };
      }).toList();
    });
  }
}
