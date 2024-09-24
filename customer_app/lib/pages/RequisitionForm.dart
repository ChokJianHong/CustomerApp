import 'package:customer_app/Assets/components/CategoryButton.dart';
import 'package:customer_app/Assets/components/Divider.dart';
import 'package:customer_app/Assets/components/button.dart';
import 'package:customer_app/core/configs/theme/app_colors.dart';
import 'package:customer_app/pages/ConfirmationRequest.dart';
import 'package:customer_app/pages/HomePage.dart';
import 'package:flutter/material.dart';

class RequisitionForm extends StatefulWidget {
  const RequisitionForm({super.key});

  @override
  State<RequisitionForm> createState() => _RequisitionFormState();
}

class _RequisitionFormState extends State<RequisitionForm> {
  bool isAlarmSelected = false;
  bool isAutogateSelected = false;

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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'CATEGORIES',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.grey,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Alarm System Button
                  categoryButton(
                    label: 'Alarm System',
                    imagePath: 'lib/Assets/photos/Alarm.png',
                    isSelected: isAlarmSelected,
                    onTap: () {
                      setState(() {
                        isAlarmSelected = true; // Select the Alarm button
                        isAutogateSelected = false; // Deselect the other option
                      });
                    },
                  ),

                  // Autogate System Button
                  categoryButton(
                    label: 'AutoGate System',
                    imagePath: 'lib/Assets/photos/Autogate.png',
                    isSelected: isAutogateSelected,
                    onTap: () {
                      setState(() {
                        isAutogateSelected = true; // Select the Autogate button
                        isAlarmSelected = false; // Deselect the Alarm option
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const ADivider(),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "DATE & TIME",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Date:  17 July 2024',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Time:  4:00 P.M',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const ADivider(),
              const Text(
                'EMERGENCY LEVEL',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('STANDRAD'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('URGENT'),
                  ),
                  ElevatedButton(
                      onPressed: () {}, child: const Text('EMERGENCY')),
                ],
              ),
              const ADivider(),
              const Text(
                'PROBLEM DESCRIPTION',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Padding(
                  padding:
                      EdgeInsets.all(8.0), // Add padding inside the container
                  child: TextField(
                    maxLines: null, // Allow multiple lines
                    decoration: InputDecoration(
                      border:
                          InputBorder.none, // Remove border of the TextField
                    ),
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const ADivider(),
              const Text(
                'PICTURE OF PROBLEM',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Container(
                width: double.infinity,
                color: AppColors.secondary,
                child: ElevatedButton(
                  onPressed: () {},
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  child: const Text(
                    'Insert Picture',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              MyButton(
                text: 'Continue',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ConfirmationRequest()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
