import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart'; // Import image picker
import 'package:path/path.dart' as path;

class DisplayPictureScreen extends StatefulWidget {
  final String token; // Accept the token here

  const DisplayPictureScreen(String imagePath,
      {super.key, required this.token});

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  bool _isUploading = false; // Track upload status
  String? _uploadMessage; // Message to display after upload
  File? _imageFile; // Variable to hold the selected image

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadPicture() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first.')),
      );
      return;
    }

    setState(() {
      _isUploading = true; // Start uploading
      _uploadMessage = null; // Reset the message
    });

    try {
      var uri = Uri.parse(
          'http://10.0.2.2:5005/dashboarddatabase/orders'); // Adjust this URL to your server endpoint
      var request = http.MultipartRequest('POST', uri);

      // Attach the token to the headers
      request.headers['Authorization'] = widget.token;
      request.headers['userType'] = 'customer';

      // Attach the file to the request
      var filePart = await http.MultipartFile.fromPath(
          'image', _imageFile!.path,
          filename: path.basename(_imageFile!.path));
      request.files.add(filePart);

      var response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        final jsonData = json.decode(responseData);
        setState(() {
          _uploadMessage = 'Upload successful! Image URL: ${jsonData['url']}';
        });
      } else {
        throw Exception('Failed to upload image: ${response.reasonPhrase}');
      }
    } catch (e) {
      setState(() {
        _uploadMessage = 'Error uploading image: $e';
      });
    } finally {
      setState(() {
        _isUploading = false; // Stop uploading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload an Image')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_imageFile != null) ...[
              Image.file(_imageFile!,
                  height: 200, width: 200, fit: BoxFit.cover),
              const SizedBox(height: 20),
            ],
            ElevatedButton(
              onPressed: _pickImage, // Trigger image picking
              child: const Text('Select Image'),
            ),
            const SizedBox(height: 20),
            if (_isUploading)
              const CircularProgressIndicator() // Show loading indicator
            else
              ElevatedButton(
                onPressed: _uploadPicture, // Trigger the upload
                child: const Text('Upload Picture'),
              ),
            if (_uploadMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  _uploadMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _uploadMessage!.startsWith('Error')
                        ? Colors.red
                        : Colors.green,
                    fontSize: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
