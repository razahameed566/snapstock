import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:image_picker/image_picker.dart';

class UploadTab extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<UploadTab> {
  /// Variables

  DatabaseMethods databaseMethods = DatabaseMethods();
  XFile? pickedFile;
  var imageFile;

  /// Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: imageFile == null
          ? Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    // color: Colors.greenAccent,
                    onPressed: () {
                      _getFromGallery();
                    },
                    child: Text("PICK FROM GALLERY"),
                  ),
                  Container(
                    height: 40.0,
                  ),
                  ElevatedButton(
                    // color: Colors.lightGreenAccent,
                    onPressed: () {
                      _getFromCamera();
                    },
                    child: const Text("PICK FROM CAMERA"),
                  )
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.center,
                  ),
                  Image.file(
                    imageFile,
                    fit: BoxFit.cover,
                  ),
                  ElevatedButton(
                      onPressed: uploadImage(),
                      child: const Text('Upload Image')),
                ],
              ),
            ),
    ));
  }

  /// Get from gallery
  _getFromGallery() async {
    pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile!.path);
      });
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  uploadImage() {
    Map<String, String> imagesMap = {
      "pickedFile": imageFile.toString(),
    };

    databaseMethods.addImages(imagesMap);
  }
}
