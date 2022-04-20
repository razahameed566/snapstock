import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/mainScreen.dart';
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
  bool isLoading = false;
  String imageName = '';

  /// Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? Container(
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(
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
                                onPressed: (() => uploadImage()),
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
        imageName = File(pickedFile!.name).toString();
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
        imageName = File(pickedFile.name).toString();
      });
    }
  }

  uploadImage() async {
    // Map<String, String> imagesMap = {
    //   "pickedFile": imageFile.toString(),
    // };

    setState(() {
      isLoading = true;
    });
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(imageName);
    UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then((value) => print("Done:$value"));
    setState(() {
      isLoading = false;
    });

    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(const Duration(seconds: 5), () {
            Navigator.of(context).pop(true);
          });
          return const AlertDialog(
            title: Text(
              'Image Uploaded Successfully',
            ),
          );
        });

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MainScreen()));

    // databaseMethods.addImages(imagesMap);
  }
}
