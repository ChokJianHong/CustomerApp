import 'package:customer_app/assets/components/textbox.dart';
import 'package:customer_app/core/app_colors.dart';
import 'package:customer_app/pages/Confirmation.dart';
import 'package:flutter/material.dart';

class CancelOrder extends StatelessWidget {
  final String token;
  const CancelOrder({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'REASON OF CANCELLATION',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Padding(
                padding:
                    EdgeInsets.all(8.0), // Add padding inside the container
                child: TextField(
                  maxLines: null, // Allow multiple lines
                  decoration: InputDecoration(
                    border: InputBorder.none, // Remove border of the TextField
                  ),
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            MyButton(
              text: 'Send Cancellation',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ConfirmationRequest(
                            token: token, orderId: null,
                          )),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
