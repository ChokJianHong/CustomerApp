import 'package:customer_app/Assets/components/CategoryButton.dart';
import 'package:customer_app/core/configs/theme/app_colors.dart';
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
            Navigator.pop(context); // Pop the current page and go back
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
                    fontSize: 18,
                    color: AppColors.grey),
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
                    imagePath: 'lib/pages/Alarm.png',
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
                    imagePath: 'lib/pages/Autogate.png',
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
            ],
          ),
        ),
      ),
    );
  }
}
