import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cross_file_image/cross_file_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool textScanning = false;

  XFile? imageFile;

  String? image_url;

  String scannedText = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.indigo,
        title: const Text("Image to text"),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white70,
          child: ListView(
            children: <Widget>[
              const DrawerHeader(
                  child: Center(
                child: Icon(
                  Icons.image_search,
                  size: 100,
                  color: Colors.indigo,
                ),
              )),
              const ListTile(
                title: Text(
                  "I M A G E - T O - T E X T - A P P",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo),
                ),
              ),
              GestureDetector(
                onTap: () {
                  getImage(ImageSource.camera);
                },
                child: const ListTile(
                  leading:
                      Icon(Icons.camera_alt_outlined, color: Colors.indigo),
                  title: Text(
                    "Capture Image",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.indigo),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  getImage(ImageSource.gallery);
                },
                child: const ListTile(
                  leading: Icon(Icons.image, color: Colors.indigo),
                  title: Text(
                    "Add Image From Gallery",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.indigo),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _signOut();
                },
                child: const ListTile(
                  leading: Icon(Icons.logout, color: Colors.indigo),
                  title: Text(
                    "Logout",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.indigo),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              if (textScanning)
                const Center(
                  child: CircularProgressIndicator(),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  width: double.infinity,
                  height: 300,
                  color: Colors.grey[300]!,
                  child:  imageFile != null
                  ? Image(image: XFileImage(imageFile!), width: double.infinity, height: 300, fit: BoxFit.fill)
                      : const SizedBox(),
                ),
              const SizedBox(
                height: 16,
              ),
              Text(
                scannedText,
                style: const TextStyle(fontSize: 17),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FloatingActionButton.extended(
              heroTag: "camera",
              label: const Text('Camera'),
              icon: const Icon(Icons.camera_alt_outlined),
              onPressed: () => getImage(ImageSource.camera),
            ),
            FloatingActionButton.extended(
              heroTag: "gallery",
              label: const Text('Gallery'),
              icon: const Icon(Icons.image),
              onPressed: () => getImage(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  void getRecognisedText(XFile  image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textDetector();
    RecognisedText recognisedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = "$scannedText${line.text}\n";
      }
    }
    textScanning = false;
    setState(() {});
  }

  Future getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        getRecognisedText(pickedImage);
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      scannedText = "Error occurred while scanning";
      print("Error: ${e}");
      setState(() {});
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
