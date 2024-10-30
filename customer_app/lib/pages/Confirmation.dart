import 'package:customer_app/API/cancelCustOrder.dart';
import 'package:customer_app/assets/components/textbox.dart';
import 'package:customer_app/core/app_colors.dart';
import 'package:customer_app/pages/home.dart';
import 'package:flutter/material.dart';

class ConfirmationRequest extends StatelessWidget {
  final String token;
  final String? orderId;

  const ConfirmationRequest({
    super.key,
    required this.token,
    required this.orderId,
  });

  Future<void> _cancelOrder(BuildContext context) async {
    final api = GetCancelOrder();
    try {
      // Call the API without the cancel details
      final response = await api.cancelOrder(token, orderId!, "");

      if (response['status'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order cancelled successfully.')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage(token: token)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response['message'] ?? 'Failed to cancel order')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error cancelling order.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 50),
            const Center(
              child: Image(image: AssetImage('lib/assets/images/Time.png')),
            ),
            const SizedBox(height: 20),
            const Text(
              '2 minutes will be given to you to cancel the order',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            MyButton(
              text: 'Cancel Order',
              onTap: () => _cancelOrder(context),
              backgroundColor: AppColors.secondary,
            ),
            const SizedBox(height: 20),
            MyButton(
              text: 'Go Back Home',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(token: token),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
