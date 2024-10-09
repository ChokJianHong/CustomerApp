import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CaptureImageScreen extends StatefulWidget {
  @override
  _CaptureImageScreenState createState() => _CaptureImageScreenState();
}

class _CaptureImageScreenState extends State<CaptureImageScreen> {
  File? _image;

  Future<void> _captureImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Capture Image'),
      ),
      body: Container(
        // Ensure the body has constraints
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Constrain the height of the Column
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _captureImage,
              child: Text('Capture Image'),
            ),
            SizedBox(height: 20),
            // Use a Container to constrain the size of the image display
            if (_image != null)
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey), // Optional border
                ),
                child: ClipRect(
                  child: Image.file(
                    _image!,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Text('No image captured.'),
          ],
        ),
      ),
    );
  }
}
