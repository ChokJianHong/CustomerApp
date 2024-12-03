import 'dart:async';
import 'dart:io';
import 'dart:convert'; // Import for JSON encoding
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import HTTP package
import 'package:path/path.dart' as path; // For extracting the filename

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: TakePictureScreen(camera: firstCamera),
    ),
  );
}

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({super.key, required this.camera});

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();

            if (!context.mounted) return;

            // Navigate to the display screen and upload the picture
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    DisplayPictureScreen(imagePath: image.path),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  Future<void> _uploadPicture(BuildContext context) async {
    try {
      // Validate that the image exists at the given path
      final file = File(imagePath);
      if (!file.existsSync()) {
        throw Exception(
            'File does not exist at the specified path: $imagePath');
      }

      // Create a multipart request
      var uri = Uri.parse(
          'http://10.0.2.2:5005/orders'); // Replace with your server URL
      var request = http.MultipartRequest('POST', uri);

      // Add the image file to the request
      var filePart = await http.MultipartFile.fromPath('image', imagePath,
          filename: path.basename(imagePath));
      request.files.add(filePart);

      // Send the request
      var response = await request.send();

      // Log the status code and response body
      print('Response status: ${response.statusCode}');
      final responseData = await response.stream.bytesToString();
      print('Response body: $responseData');

      if (response.statusCode == 200) {
        // If upload was successful, handle response here (e.g., show a success message)
        final jsonData = json.decode(responseData);
        final imageUrl = jsonData['url']; // Assuming server returns a URL

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload successful! Image URL: $imageUrl')),
        );

        // Optionally, you can navigate to order creation and send the image URL
        await _navigateToOrderCreation(context, imageUrl);
      } else {
        throw Exception('Failed to upload image: ${response.reasonPhrase}');
      }
    } catch (e, stackTrace) {
      print('Error uploading image: $e');
      print('Stack trace: $stackTrace'); // Log the stack trace
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
    }
  }

  Future<void> _navigateToOrderCreation(
      BuildContext context, String imageUrl) async {
    // Assuming you have a method to navigate to the order creation screen
    // You can pass the imageUrl to that screen
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OrderCreationScreen(imageUrl: imageUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Column(
        children: [
          Expanded(child: Image.file(File(imagePath))),
          ElevatedButton(
            onPressed: () => _uploadPicture(context),
            child: const Text('Upload Picture'),
          ),
        ],
      ),
    );
  }
}

// OrderCreationScreen should be defined to handle order creation with the image URL
class OrderCreationScreen extends StatelessWidget {
  final String imageUrl;

  const OrderCreationScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    // Your order creation form UI goes here
    // Use the imageUrl as needed for the order creation
    return Scaffold(
      appBar: AppBar(title: const Text('Create Order')),
      body: Center(
        child:
            Text('Image URL: $imageUrl'), // Display or use the URL in the form
      ),
    );
  }
}
