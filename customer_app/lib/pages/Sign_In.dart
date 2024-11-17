import 'package:customer_app/API/getCustToken.dart';
import 'package:customer_app/Assets/components/button.dart';
import 'package:customer_app/assets/components/textbox.dart';
import 'package:customer_app/core/app_colors.dart';
import 'package:customer_app/pages/Register.dart';
import 'package:customer_app/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:customer_app/API/SignInAPI.dart';
import 'package:flutter/gestures.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  // Initialize the FlutterSecureStorage
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();

    _checkLoggedInStatus();
  }

  // Forgot Password Function
  void _forgotPassword() async {
    final TextEditingController emailController = TextEditingController();
    String? userType = 'customer'; // Default user type

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Forgot Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration:
                    const InputDecoration(labelText: 'Enter your email'),
              ),
              DropdownButton<String>(
                value: userType,
                onChanged: (String? newValue) {
                  setState(() {
                    userType = newValue!;
                  });
                },
                items: <String>['customer', 'technician']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final email = emailController.text;

                if (email.isEmpty || !EmailValidator.validate(email)) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Please enter a valid email')));
                  return;
                }

                try {
                  final response = await http.post(
                    Uri.parse(
                        'http://82.112.238.13:5005/dashboarddatabase/forgot-password'),
                    headers: {'Content-Type': 'application/json'},
                    body: json.encode({
                      'email': email,
                      'userType': userType,
                    }),
                  );

                  final responseData = json.decode(response.body);
                  if (response.statusCode == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(responseData['message'] ??
                            'Password reset email sent!')));
                    Navigator.pop(context); // Close the dialog
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(responseData['message'] ??
                            'Failed to send reset email')));
                  }
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error occurred: $error')));
                }
              },
              child: const Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Check if a valid token exists in storage
  Future<void> _checkLoggedInStatus() async {
    final token = await storage.read(key: 'userToken');

    if (token != null) {
      // If a token exists, navigate directly to the home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(token: token)),
      );
    }
  }

  bool _validateInputs() {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty || !EmailValidator.validate(email)) {
      setState(() {
        errorMessage = 'Please enter a valid email address.';
      });
      return false;
    }

    if (password.isEmpty) {
      setState(() {
        errorMessage = 'Password cannot be empty.';
      });
      return false;
    }

    return true;
  }

  void _signIn() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    if (!_validateInputs()) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final api = SignInAPI();
      final userData =
          await api.loginUser(emailController.text, passwordController.text);

      // Assuming the token is returned in the 'token' field
      final token = userData['token'];
      print('Token: $token');

      // Store the token securely
      await storage.write(key: 'userToken', value: token);

      // Fetch customer details using the token
      await _getCustomerDetails(token);

      // Navigate to home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                  token: token,
                )),
      );
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _getCustomerDetails(String token) async {
    try {
      final customerTokenApi = CustomerToken();
      final customerData = await customerTokenApi.getCustomerByToken(token);
      print('Customer Data: $customerData');
      // Handle customer data (e.g., store it, display it, etc.)
    } catch (e) {
      print('Error fetching customer details: $e');
      // Handle errors accordingly
    }
  }

  // Forgot Password Function
  void _forgotPassword() async {
    final TextEditingController emailController = TextEditingController();
    String? userType = 'customer'; // Default user type

    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                onChanged: (String? newValue) {
                  setState(() {
                    userType = newValue!;
                  });
                },
                items: <String>['customer', 'technician']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final email = emailController.text;

                if (email.isEmpty || !EmailValidator.validate(email)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid email')));
                  return;
                }

                try {
                  final response = await http.post(
                    Uri.parse(
                        'http://82.112.238.13:5005/dashboarddatabase/forgot-password'),
                    headers: {'Content-Type': 'application/json'},
                    body: json.encode({
                      'email': email,
                      'userType': userType,
                    }),
                  );

                  final responseData = json.decode(response.body);
                  if (response.statusCode == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(responseData['message'] ??
                            'Password reset email sent!')));
                    Navigator.pop(context); // Close the dialog
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(responseData['message'] ??
                            'Failed to send reset email')));
                  }
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error occurred: $error')));
                }
              },
              child: const Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkblue,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('lib/assets/images/signinlock.png'),
                const SizedBox(height: 20),
                const Text('Welcome Back!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    )),
                const SizedBox(height: 20),
                MyTextField(
                  controller: emailController,
                  hintText: 'Email Address',
                  obscureText: false,
                ),
                const SizedBox(height: 20),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                Container(
                  alignment: Alignment.centerRight, // Aligns to the right
                  child: TextButton(
                    onPressed:
                        _forgotPassword, // Trigger forgot password dialog
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    ),
                  ),
                ),
                if (errorMessage != null)
                  Text(errorMessage!,
                      style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 10),
                isLoading
                    ? const CircularProgressIndicator()
                    : MyButton(
                        text: "Sign In",
                        onTap: _signIn,
                        backgroundColor: AppColors.orange,
                      ),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    text: 'Not a member? ',
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Register Now',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Register()));
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
