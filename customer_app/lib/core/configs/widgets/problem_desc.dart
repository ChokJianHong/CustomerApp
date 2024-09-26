import 'package:flutter/material.dart';

class ProblemDescriptionField extends StatelessWidget {
  const ProblemDescriptionField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: TextField(
          maxLines: null,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
