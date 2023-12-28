import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:qurankhwani/group_screen.dart';

class GridEdit extends StatefulWidget {
  var id;
  GridEdit(this.id);

  @override
  State<GridEdit> createState() => _GridEditState();
}

class _GridEditState extends State<GridEdit> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final grName = TextEditingController();
    final reason = TextEditingController();
    final memberNo = TextEditingController();
    final ButtonStyle style = ElevatedButton.styleFrom(
        backgroundColor: HexColor("#2a6e2d"),
        textStyle: const TextStyle(fontSize: 20));
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green[400]!, Colors.green[700]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            title: const Text(
              "Edit Groups",
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'Schyler',
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: grName,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hoverColor: HexColor("#2a6e2d"),
                        hintText: 'Group Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter something';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: reason,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hoverColor: HexColor("#2a6e2d"),
                        hintText: 'Reason for Quran Khwani',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter something';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: memberNo,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hoverColor: HexColor("#2a6e2d"),
                        hintText: 'Total Member',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter something';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      style: style,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          var uservalue =
                              await FirebaseAuth.instance.signInAnonymously();
                          await FirebaseFirestore.instance
                              .collection("Groups")
                              .doc(widget.id)
                              .update({
                            'userID': uservalue.user?.uid,
                            'groupName': grName.text,
                            'reason': reason.text,
                            'groupMember': int.parse(memberNo.text),
                          });

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      GroupScreen(false)));
                        }
                      },
                      child: const Text('Edit Group'),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
