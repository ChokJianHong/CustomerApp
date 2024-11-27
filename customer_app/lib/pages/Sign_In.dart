import 'package:customer_app/API/SignInAPI.dart';
import 'package:customer_app/API/getCustToken.dart';
import 'package:customer_app/Assets/components/button.dart';
import 'package:customer_app/assets/components/forgetPass.dart';
import 'package:customer_app/assets/components/textbox.dart';
import 'package:customer_app/core/app_colors.dart';
import 'package:customer_app/pages/Register.dart';
import 'package:customer_app/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final storage = const FlutterSecureStorage();

  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _checkLoggedInStatus();
  }

  Future<void> _checkLoggedInStatus() async {
    final token = await storage.read(key: 'userToken');
    if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(token: token)),
      );
    }
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

      final token = userData['token'];
      await storage.write(key: 'userToken', value: token);
      await _getCustomerDetails(token);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(token: token)),
      );
    } catch (e) {
      setState(() {
        errorMessage = "Invalid email or password. Please try again.";
        isLoading = false;
      });
    }
  }

  Future<void> _getCustomerDetails(String token) async {
    try {
      final customerTokenApi = CustomerToken();
      final customerData = await customerTokenApi.getCustomerByToken(token);
      print('Customer Data: $customerData');
    } catch (e) {
      print('Error fetching customer details: $e');
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

  void _forgotPassword() {
    showDialog(
      context: context,
      builder: (context) => const ForgotPasswordDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'lib/assets/images/Logo.png',
                  width: screenWidth * 0.5,
                ),
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
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _forgotPassword,
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                ),
                if (errorMessage != null)
                  Text(errorMessage!,
                      style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 20),
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
