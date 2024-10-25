import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

class MyApp extends StatelessWidget {
  final CameraDescription camera;
  final String token;

  const MyApp({Key? key, required this.camera, required this.token})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera App',
      home: TakePictureScreen1(
        camera: camera,
        token: token,
      ),
    );
  }
}

class TakePictureScreen1 extends StatefulWidget {
  final CameraDescription camera;
  final String token;

  const TakePictureScreen1(
      {super.key, required this.camera, required this.token});

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen1> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _uploadPicture(String imagePath, String token) async {
    try {
      final file = File(imagePath);
      if (!file.existsSync()) {
        throw Exception(
            'File does not exist at the specified path: $imagePath');
      }

      var uri = Uri.parse(
          'http://10.0.2.2:5005/dashboarddatabase/orders'); // Adjust this URL to your server endpoint
      var request = http.MultipartRequest('POST', uri);

      // Attach the token to the headers
      request.headers['Authorization'] = token;

      // Attach the file to the request
      var filePart = await http.MultipartFile.fromPath('image', imagePath);
      request.files.add(filePart);

      var response = await request.send();

      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        final jsonData = json.decode(responseData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Upload successful! Image URL: ${jsonData['url']}')),
        );
      } else {
        throw Exception('Failed to upload image: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a Picture')),
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

            // Upload the picture
            await _uploadPicture(image.path, widget.token);
          } catch (e) {
            print(e);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error taking picture: $e')),
            );
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
