import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:qurankhwani/GameLists.dart';
import 'package:qurankhwani/group_screen.dart';
import 'package:qurankhwani/main.dart' as main;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

class IntroName extends StatefulWidget {
  var name;
  IntroName(this.name);

  @override
  State<IntroName> createState() => _IntroNameState();
}

class _IntroNameState extends State<IntroName> {
  final ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: HexColor("#2a6e2d"),
      textStyle: const TextStyle(fontSize: 20));
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  final email = TextEditingController();

  var _image;
  var value;
  _imgFromGallery() async {
    PickedFile? image = await ImagePicker.platform
        .pickImage(source: ImageSource.gallery, imageQuality: 50);

    File selected = File(image!.path);

    setState(() {
      _image = selected;
      value = image.path;
    });
  }

  startTime(name) async {
    var duration = const Duration(seconds: 2);
    if (name == 'grp') {
      return Timer(duration, route);
    } else {
      return Timer(duration, route1);
    }
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => GroupScreen(false)));
  }

  route1() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const GameLists()));
  }

  _imgFromCamera() async {
    PickedFile? image = await ImagePicker.platform
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    File selected = File(image!.path);

    setState(() {
      _image = selected;
      value = image.path;
    });
  }

  getUserName() async {
    var uservalue = await FirebaseAuth.instance.signInAnonymously();
    var querySnapshot = await FirebaseFirestore.instance
        .collection("Users")
        .where("userID", isEqualTo: uservalue.user?.uid)
        .get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    setState(() {
      main.url = File(allData[0]['image']);
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: MediaQuery.of(context).size.longestSide,
            width: MediaQuery.of(context).size.longestSide,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: HexColor("#2a6e2d"),
                width: 5, // red as border color
              ),
            ),
            child: SingleChildScrollView(
                child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    "assets/image/Qurankhwani.png",
                    height: 200,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      "Welcome to Quran Khwani",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Schyler',
                          color: HexColor("#2a6e2d")),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Please Fill this form to create Groups",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Schyler',
                          color: HexColor("#2a6e2d")),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: const Color(0xffFDCF09),
                        child: _image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(
                                  _image,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fitHeight,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(50)),
                                width: 100,
                                height: 100,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey[800],
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              "Enter Your Name",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Schyler',
                                  color: HexColor("#2a6e2d")),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextFormField(
                              controller: myController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hoverColor: HexColor("#2a6e2d"),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter something';
                                }
                                return null;
                              },
                            ),
                          ),
                          Center(
                            child: Text(
                              "Enter Your Email",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Schyler',
                                  color: HexColor("#2a6e2d")),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextFormField(
                              controller: email,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hoverColor: HexColor("#2a6e2d"),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter something';
                                }
                                return null;
                              },
                            ),
                          ),
                          ElevatedButton(
                            style: style,
                            onPressed: () async {
                              Random random = Random();
                              String colorString = Color.fromRGBO(
                                random.nextInt(255),
                                random.nextInt(255),
                                random.nextInt(255),
                                1,
                              ).toString();
                              String colorSplit = colorString
                                  .replaceAll('Color(0x', '')
                                  .replaceAll(')', '');
                              if (_formKey.currentState!.validate()) {
                                var uservalue = await FirebaseAuth.instance
                                    .signInAnonymously();
                                await FirebaseFirestore.instance
                                    .collection("Users")
                                    .add({
                                  'userID': uservalue.user?.uid,
                                  'userName': myController.text,
                                  'email': email.text,
                                  'hexColor': colorSplit,
                                  'image': value.toString()
                                });
                                getUserName();
                                startTime(widget.name);
                              }
                            },
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                fontFamily: 'Schyler',
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            )),
          ),
        ),
      ),
    );
  }
}
