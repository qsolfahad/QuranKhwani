import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:qurankhwani/GameOptionPage.dart' as val;
import 'package:qurankhwani/main.dart';

class GameResult extends StatefulWidget {
  var gameName;
  var time;
  int order;
  GameResult(this.gameName, this.time, this.order);

  @override
  State<GameResult> createState() => _GameResultState();
}

class _GameResultState extends State<GameResult> {
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();

  final ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: HexColor("#2a6e2d"),
      textStyle: const TextStyle(fontSize: 20));
  @override
  void initState() {
    loadResult();
  }

  loadResult() async {
    var uservalue = await FirebaseAuth.instance.signInAnonymously();
    var userName = '';
    var data = await FirebaseFirestore.instance
        .collection("Users")
        .where("userID", isEqualTo: uservalue.user?.uid)
        .get()
        .then((value) => value.docs.forEach((element) {
              userName = element.data()['userName'];
            }));
    var check = 0;
    var data1 = await FirebaseFirestore.instance
        .collection("GameResult")
        .where("userId", isEqualTo: uservalue.user?.uid)
        .where('gameName', isEqualTo: widget.gameName)
        .get()
        .then((value) => check = value.size);
    if (check == 0) {
      await FirebaseFirestore.instance.collection('GameResult').add({
        'userName': userName,
        'points': (widget.order == 0) ? val.result : widget.order,
        'time': (widget.order == 0) ? '' : widget.time,
        'userId': uservalue.user?.uid,
        'gameName': widget.gameName,
      });
    } else {
      await FirebaseFirestore.instance
          .collection('GameResult')
          .where('userId', isEqualTo: uservalue.user?.uid)
          .where('gameName', isEqualTo: widget.gameName)
          .get()
          .then((value) => value.docs.forEach((element) {
                if (((widget.order == 0) ? val.result : widget.order) >
                    element.data()['points']) {
                  FirebaseFirestore.instance
                      .collection('GameResult')
                      .doc(element.id)
                      .update({
                    'userName': userName,
                    'points': (widget.order == 0) ? val.result : widget.order,
                    'time': (widget.order == 0) ? '' : widget.time,
                    'userId': uservalue.user?.uid,
                    'gameName': widget.gameName,
                  });
                }
              }));
    }
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
                      "Hope you enjoy the quiz!!",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Schyler',
                          color: HexColor("#2a6e2d")),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
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
                              "Result",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Schyler',
                                  color: HexColor("#2a6e2d")),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  (widget.order != 0)
                                      ? "You have completed the Puzzle in " +
                                          widget.time
                                      : "You have score " +
                                          val.result.toString() +
                                          " out of 5.",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Schyler',
                                      color: HexColor("#2a6e2d")),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            style: style,
                            onPressed: () async {
                              val.pageCount = 1;
                              val.result = 0;
                              time = '';
                              order = 0;
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Close',
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
