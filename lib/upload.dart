import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadTab extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<UploadTab> {
  /// Variables

  XFile? pickedFile;
  var imageFile, imageName;
  late FirebaseStorage storage;

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
                  OutlinedButton(
                      onPressed: uploadImageToFirebase(),
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
        imageName = File(pickedFile!.name);

        // Create a storage reference from our app
        storage = imageFile.getReference();
        print(storage);
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
        imageName = File(pickedFile.name);

        // Create a storage reference from our app
        storage = imageFile.getReference();
        print(storage);
      });
    }
  }

  uploadImageToFirebase() {}
}
