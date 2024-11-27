import 'package:flutter/material.dart';

class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({super.key});

  @override
  _ForgotPasswordDialogState createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final emailController = TextEditingController();
  String userType = 'customer';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Forgot Password'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Enter your email'),
          ),
          DropdownButton<String>(
            value: userType,
            onChanged: (newValue) {
              setState(() {
                userType = newValue!;
              });
            },
            items: ['customer', 'technician']
                .map((value) =>
                    DropdownMenuItem(value: value, child: Text(value)))
                .toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            // Send forgot password request
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
