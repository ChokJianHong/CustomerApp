// customer_id_page.dart
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class CustomerIDPage extends StatelessWidget {
  final String token;

  CustomerIDPage({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fetch Customer ID"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Decode the token to get the customer ID
            Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
            int customerId = decodedToken[
                'customer_id']; // Assuming the key is 'customer_id'

            // Navigate back with the customer ID
            Navigator.pop(context, customerId);
          },
          child: Text("Get Customer ID"),
        ),
      ),
    );
  }
}
