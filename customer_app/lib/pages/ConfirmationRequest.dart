import 'package:customer_app/Assets/components/button.dart';
import 'package:customer_app/core/configs/theme/app_colors.dart';
import 'package:customer_app/pages/CancelOrder.dart';
import 'package:customer_app/pages/HomePage.dart';
import 'package:flutter/material.dart';

class ConfirmationRequest extends StatelessWidget {
  const ConfirmationRequest({super.key});

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
            const Center(child: Image(image: AssetImage('lib/Assets/photos/Time.png'))),
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
                        builder: (context) => const CancelOrder()),
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
                        builder: (context) => const HomePage()),
                  );
              },
            ),
          ],
        ),
      ),
    );
  }
}
