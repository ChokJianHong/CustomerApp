import 'package:customer_app/Assets/components/button.dart';
import 'package:customer_app/pages/Sign_In.dart';
import 'package:flutter/material.dart';
import 'package:customer_app/core/configs/theme/app_colors.dart';


class ItemRegister extends StatelessWidget {
  const ItemRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor:
            AppColors.primary, // Match app bar color with background
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                      "Alarm System",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.lightpurple,
                      ),
                    ),
              ),
              Card(
                color: AppColors.secondary,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Alarm Brand',
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
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Alarm Warranty Date',
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                      "AutoGate System",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.lightpurple,
                      ),
                    ),
              ),
              Card(
                color: AppColors.secondary,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'AutoGate Brand',
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
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'AutoGate Warranty Date',
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: MyButton(
                      text: "Sign In",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  SignInPage()),
                        );
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
