import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:qurankhwani/GamePageView.dart';
import 'package:qurankhwani/GuessTheVoice.dart';
import 'package:qurankhwani/jigsawPuzzle.dart';
import 'package:qurankhwani/jigsaw_game.dart';

class GameOption extends StatefulWidget {
  var value;

  GameOption(this.value);

  @override
  State<GameOption> createState() => _GameOptionState();
}

enum SingingCharacter { letter, word }

SingingCharacter? character = SingingCharacter.letter;
int pageCount = 1;
int result = 0;

class _GameOptionState extends State<GameOption> {
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();

  final ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: HexColor("#2a6e2d"),
      textStyle: const TextStyle(fontSize: 20));
  @override
  void initState() {
    pageCount = 1;
    result = 0;
    // TODO: implement initState
    super.initState();
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
                      (widget.value == 'Game')
                          ? "Welcome to Quran Quiz"
                          : "Welcome to " + widget.value,
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Schyler',
                          color: HexColor("#2a6e2d")),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Please Fill this form to play game",
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
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              "Option",
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
                          Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  'Letters',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontFamily: 'Schyler',
                                    color: HexColor("#2a6e2d"),
                                  ),
                                ),
                                leading: Radio<SingingCharacter>(
                                  value: SingingCharacter.letter,
                                  groupValue: character,
                                  onChanged: (SingingCharacter? value) {
                                    setState(() {
                                      character = value;
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  'Words',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontFamily: 'Schyler',
                                    color: HexColor("#2a6e2d"),
                                  ),
                                ),
                                leading: Radio<SingingCharacter>(
                                  value: SingingCharacter.word,
                                  groupValue: character,
                                  onChanged: (SingingCharacter? value) {
                                    setState(() {
                                      character = value;
                                    });
                                  },
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
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => (widget.value ==
                                            'Game')
                                        ? const GamePageView()
                                        : (widget.value == 'Guess the Voice')
                                            ? const GuessTheVoice()
                                            : PuzzleGame()),
                              );
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
