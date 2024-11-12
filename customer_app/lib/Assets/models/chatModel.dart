import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;
  final String status; // Add status field

  // Updated constructor
  ChatMessage({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.status =
        'sent', // Default status can be 'sent' or another default value
  });

  // Updated toMap method
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
      'status': status, // Add status to map
    };
  }

  // Updated fromMap factory constructor
  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      message: map['message'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      status: map['status'] ?? 'sent', // Default to 'sent' if status is missing
    );
  }
}
