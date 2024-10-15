import 'package:flutter/material.dart';

class RequisitionForm1 extends StatefulWidget {
  final String token;
  const RequisitionForm1({super.key, required this.token});

  @override
  _RequisitionFormState1 createState() => _RequisitionFormState1();
}

class _RequisitionFormState1 extends State<RequisitionForm1> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedLocation;
  String? selectedEmergencyLevel;
  String? problemDescription;
  String? selectedCategory;

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  bool isFirstBuild = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    selectedTime = TimeOfDay.now();
  }

  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Handle form submission logic here
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Form Submitted')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
