import 'package:customer_app/API/SignInAPI.dart';
import 'package:customer_app/Assets/components/button.dart';
import 'package:customer_app/Assets/components/text_box.dart';
import 'package:customer_app/pages/HomePage.dart';
import 'package:customer_app/pages/Reqister.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart'; // Import the email validator package

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
      errorMessage = null; // Reset error message
    });

    if (!_validateInputs()) {
      setState(() {
        isLoading = false; // Stop loading if validation fails
      });
      return; // Exit if validation fails
    }

    try {
      final api = SignInAPI();
      final userData = await api.SignInUser(
        emailController.text,
        passwordController.text,
      );
      print('User Data: $userData');
      // Navigate to home page or handle success
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      setState(() {
        errorMessage = e.toString(); // Set error message
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Logo
                Image.asset('lib/assets/photos/signinlock.png'),
                const SizedBox(height: 20),
                const Text('Welcome Back!',
                    style: TextStyle(
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
                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 20),
                isLoading
                    ? CircularProgressIndicator()
                    : MyButton(
                        text: "Sign In",
                        onTap: _signIn,
                      ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Expanded(
                      child: Divider(
                          thickness: 1, color: Colors.white, endIndent: 10),
                    ),
                    Text("or continue with",
                        style:
                            TextStyle(color: Colors.grey[400], fontSize: 14)),
                    const Expanded(
                      child: Divider(
                          thickness: 1, color: Colors.white, endIndent: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.account_circle),
                      color: Colors.white,
                      iconSize: 50,
                      onPressed: () {
                        // Handle Google login
                      },
                    ),
                    const SizedBox(width: 30),
                    IconButton(
                      icon: const Icon(
                          Icons.settings), // Substitute with your second icon
                      color: Colors.white,
                      iconSize: 50,
                      onPressed: () {
                        // Handle second login
                      },
                    ),
                  ],
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
                                  builder: (context) => Register()),
                            );
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
