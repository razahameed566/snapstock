import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/mainScreen.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:flutter_application_1/widget.dart';
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
  String imageName = "";
  String owner = "";
  var category = null;
  String location = "";
  late Uri downloadUri;
  late TaskSnapshot taskSnapshot;

  /// Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // extendBody: true,
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
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          const Color(0xffF1941F))),
                              onPressed: () {
                                _getFromGallery();
                              },
                              child: const Text(
                                "PICK FROM GALLERY",
                              ),
                            ),
                            Container(
                              height: 40.0,
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          const Color(0xffF1941F))),
                              onPressed: () {
                                _getFromCamera();
                              },
                              child: const Text("PICK FROM CAMERA"),
                            )
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(children: [
                          const Align(
                            alignment: Alignment.center,
                          ),
                          Image.file(
                            imageFile,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            color: Colors.black54,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: const TextSpan(
                                        text: 'Description',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        )),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        decoration:
                                            textFieldInputDecoration('name'),
                                        style: simpleTextStyle(),
                                      ),
                                      TextFormField(
                                        decoration:
                                            textFieldInputDecoration('owner'),
                                        style: simpleTextStyle(),
                                      ),
                                      TextFormField(
                                        decoration: textFieldInputDecoration(
                                            'location'),
                                        style: simpleTextStyle(),
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        child: DropdownButton<String>(
                                          value: category,
                                          hint: const Text('Select Category'),
                                          icon: const Icon(Icons
                                              .arrow_drop_down_circle_rounded),
                                          elevation: 16,
                                          style: const TextStyle(),
                                          underline: Container(
                                              // height: 2,
                                              // color: Colors.grey[600],
                                              ),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              category = newValue!;
                                            });
                                          },
                                          items: <String>[
                                            'Books',
                                            'Landscape',
                                            'People',
                                            'Animals',
                                            'Portraits',
                                            'Birds',
                                            'Others'
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                              onPressed: (() => uploadImage()),
                              child: const Text('Upload Image')),
                        ]),
                      )));
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
    taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then((value) => print("Done:$value"));

    setState(() {
      isLoading = false;
    });

    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(const Duration(seconds: 3), () {
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
