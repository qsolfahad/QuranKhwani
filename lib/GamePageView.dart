import 'dart:math';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';
import 'package:qurankhwani/GameOptionPage.dart' as char;
import 'package:qurankhwani/GameResult.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:qurankhwani/GameOptionPage.dart' as val;

class GamePageView extends StatefulWidget {
  const GamePageView({super.key});

  @override
  State<GamePageView> createState() => _GamePageViewState();
}

class _GamePageViewState extends State<GamePageView> {
  String format = char.character.toString();
  String answer = '';
  String question = '';
  int randomQ = 0;
  int render = 0;
  var questionList = [];
  final ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: HexColor("#2a6e2d"),
      textStyle: const TextStyle(fontSize: 20));
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
              child: Column(children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          child: const Text(
            'Quran Quiz',
            style: TextStyle(
                fontFamily: 'Schyler',
                fontSize: 40,
                fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: InteractiveViewer(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                      child: Container(
                    height: MediaQuery.of(context).size.longestSide,
                    width: MediaQuery.of(context).size.longestSide,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FutureBuilder(
                            future: (format.contains('letter'))
                                ? FirebaseFirestore.instance
                                    .collection("Qaida")
                                    .where('Section', isEqualTo: 'letter')
                                    .get()
                                : FirebaseFirestore.instance
                                    .collection("Qaida")
                                    .where('Section', isEqualTo: 'word')
                                    .get(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return Column(
                                children: [
                                  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: 3,
                                      itemBuilder: (context, index) {
                                        int random = Random().nextInt(
                                            snapshot.data!.docs.length);
                                        QueryDocumentSnapshot<Object?>? ds =
                                            snapshot.data?.docs[random];
                                        String element = ds!["element"];
                                        if (render == 0) {
                                          questionList.add(element);
                                        }
                                        return ListTile(
                                          title: Text(
                                            questionList[index],
                                            style: TextStyle(
                                              fontSize: 28,
                                              fontFamily: 'Schyler',
                                              color: HexColor("#2a6e2d"),
                                            ),
                                          ),
                                          leading: Radio<String>(
                                            value: questionList[index],
                                            groupValue: answer,
                                            onChanged: (value) {
                                              setState(() {
                                                answer = value.toString();
                                                render++;
                                                if (question == '') {
                                                  randomQ = Random().nextInt(
                                                      questionList.length);
                                                }

                                                question =
                                                    questionList[randomQ];
                                              });
                                            },
                                          ),
                                        );
                                      }),
                                  const SizedBox(
                                    height: 200,
                                  ),
                                  ElevatedButton(
                                    style: style,
                                    onPressed: () async {
                                      if (question == '') {
                                        randomQ = Random()
                                            .nextInt(questionList.length);
                                      }

                                      question = questionList[randomQ];

                                      FlutterTts tts = FlutterTts();
                                      tts.setLanguage("ar-SA");
                                      tts.speak(question);
                                    },
                                    child: const Text(
                                      'Play',
                                      style: TextStyle(
                                        fontFamily: 'Schyler',
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: style,
                                    onPressed: () async {
                                      FlutterTts tts = FlutterTts();
                                      tts.setLanguage("en-US");
                                      if (question != '' &&
                                          (question == answer)) {
                                        val.result++;
                                        val.pageCount++;
                                        tts.speak('Correct Answer');
                                        if (val.pageCount >= 6) {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    GameResult(
                                                        'Quran Quiz', 0, 0)),
                                          );
                                        } else {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const GamePageView()),
                                          );
                                        }
                                      } else if (question == '') {
                                        tts.speak('Please Select Option');
                                      } else {
                                        val.pageCount++;
                                        tts.speak('Wrong Answer');
                                        if (val.pageCount >= 6) {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    GameResult(
                                                        'Quran Quiz', 0, 0)),
                                          );
                                        } else {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const GamePageView()),
                                          );
                                        }
                                      }
                                    },
                                    child: const Text(
                                      'Check',
                                      style: TextStyle(
                                        fontFamily: 'Schyler',
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            })),
                  )))),
        )
      ]))),
    );
  }
}
