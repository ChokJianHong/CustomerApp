import 'package:customer_app/API/registerAPI.dart';
import 'package:flutter/material.dart';
import 'package:customer_app/Assets/components/button.dart';
import 'package:customer_app/pages/Item_Register.dart';
import 'package:customer_app/core/configs/theme/app_colors.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false; // To handle loading state

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    const emailPattern = r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!RegExp(emailPattern).hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    const phonePattern = r'^\d{10}$';
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    } else if (!RegExp(phonePattern).hasMatch(value)) {
      return 'Enter a valid phone number (10 digits)';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Let's Create Your Account",
                  style: TextStyle(
                    color: AppColors.lightpurple,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // Username
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Email
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email Address',
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: _validateEmail,
                ),
                const SizedBox(height: 20),
                // Phone Number
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: _validatePhone,
                ),
                const SizedBox(height: 20),
                // Password
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  obscureText: true,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 20),
                // Confirm Password
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  obscureText: true,
                  validator: _validateConfirmPassword,
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator() // Show loader when registering
                    : MyButton(
                        text: 'Continue',
                        onTap: () async {
                          if (_formKey.currentState?.validate() == true) {
                            setState(() {
                              _isLoading = true; // Start loading state
                            });

                            // After successful registration, navigate to the next page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ItemRegister(
                                        username: _usernameController.text,
                                        email: _emailController.text,
                                        phone: _phoneController.text,
                                        password: _passwordController.text,
                                        location: '',
                                      )),
                            );

                            setState(() {
                              _isLoading = false; // Stop loading state
                            });
                          }
                        },
                      ),
                const SizedBox(height: 20),
                // Or continue with
                Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.white,
                        endIndent: 10,
                      ),
                    ),
                    Text(
                      "or continue with  ",
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    ),
                    const Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.white,
                        endIndent: 10,
                      ),
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
                      icon: const Icon(Icons.settings),
                      color: Colors.white,
                      iconSize: 50,
                      onPressed: () {
                        // Handle other login options
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
