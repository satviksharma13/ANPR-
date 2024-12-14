import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'License Plate Detector',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final picker = ImagePicker();
  String detectedPlate = '';

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String base64Image = base64Encode(imageFile.readAsBytesSync());

      var response = await http.post(
        Uri.parse('http://your_server_ip_address:5000/process_image'),
        body: jsonEncode({'image_data': base64Image}),
      );

      if (response.statusCode == 200) {
        setState(() {
          detectedPlate = jsonDecode(response.body)['plates'][0];
        });
      } else {
        print('Failed to load plate: ${response.statusCode}');
      }
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('License Plate Detector'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: getImageFromCamera,
              child: Text('Capture Image'),
            ),
            SizedBox(height: 20),
            Text(
              'Detected License Plate:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              detectedPlate,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
