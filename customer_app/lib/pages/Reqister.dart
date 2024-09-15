import 'package:customer_app/pages/Item_Register.dart';
import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF391370),
      appBar: AppBar(
        backgroundColor:
            const Color(0xFF391370), // Match app bar color with background
        elevation: 0, // Remove shadow
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ), // Back arrow icon
          onPressed: () {
            Navigator.pop(context); // Pop the current page and go back
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Let's Create Your Account",
                style: TextStyle(
                  color: Color(0xFFF7F7F8),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //Username
              TextField(
                decoration: InputDecoration(
                  hintText: 'Username',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //Email
              TextField(
                decoration: InputDecoration(
                  hintText: 'Email Address',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //Phone Number
              TextField(
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //Password
              TextField(
                decoration: InputDecoration(
                  hintText: 'Password',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //Confirm Password
              TextField(
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ItemRegister()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A8E8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //text or continue with
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
              const SizedBox(
                height: 20,
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
