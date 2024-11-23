import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

const baseUrl = "http://82.112.238.13:5005"; // Adjust if needed

Future<void> handleBackgroundMessage(RemoteMessage message) async{
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications(String token, String customerId) async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Customer token: $token');
    print('Customer ID: $customerId');
    print('Token: $fCMToken');

    if (fCMToken != null) {
      // Insert the FCM token into the database
      await saveFcmTokenToDatabase(token, customerId, fCMToken);
      
    }

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    // Foreground message listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message - Title: ${message.notification?.title}');
      print('Foreground message - Body: ${message.notification?.body}');
      print('Foreground message - Payload: ${message.data}');
    });
  }

  Future<Map<String, dynamic>> saveFcmTokenToDatabase(String token, String customerId,String fCMToken) async {
    try {
      print('Function did get activated');
      final response = await http.post(
        Uri.parse('$baseUrl/dashboarddatabase/customer/$customerId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token, // Replace with actual auth token
          'userType': 'customer',
        },
        body: jsonEncode({
          'customerId': customerId,
          'fcmToken': fCMToken,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': 'FCM token saved successfully'};
      } else {
        return {'success': false, 'message': 'Failed to save FCM token'};
      }
    } catch (err) {
      return {'success': false, 'message': 'Error: $err'};
    }
  }
}