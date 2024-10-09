
import 'package:customer_app/assets/components/textbox.dart';
import 'package:customer_app/core/app_colors.dart';
import 'package:customer_app/pages/CancelOrder.dart';
import 'package:customer_app/pages/home.dart';
import 'package:flutter/material.dart';

class ConfirmationRequest extends StatelessWidget {
  final String token;
  const ConfirmationRequest({super.key, required this.token, required orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            const Center(
                child: Image(image: AssetImage('lib/Assets/photos/Time.png'))),
            const SizedBox(
              height: 20,
            ),
            const Text(
              '2 minutes will be given to you to cancel the order',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            MyButton(
              text: 'Cancel Order',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CancelOrder(
                            token: token,
                          )),
                );
              },
              backgroundColor: AppColors.secondary,
            ),
            const SizedBox(
              height: 20,
            ),
            MyButton(
              text: 'Go Back Home',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                            token: token,
                          )),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
