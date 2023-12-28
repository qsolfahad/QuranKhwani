import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:qurankhwani/GameOptionPage.dart';
import 'package:qurankhwani/dragAndDrop.dart';
import 'package:qurankhwani/main.dart';
import 'package:qurankhwani/quess_the_meaning.dart';
import 'package:qurankhwani/scorecard_games.dart';
import 'package:qurankhwani/suduko_puzzle.dart';
import 'package:qurankhwani/wordle.dart';

import 'jigsawPuzzle.dart';
import 'jigsaw_game.dart';

class GameLists extends StatefulWidget {
  const GameLists({super.key});

  @override
  State<GameLists> createState() => _GameListsState();
}

class _GameListsState extends State<GameLists> {
  isLandscape() {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return isLandscape;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Container(
          height: isLandscape() ? null : MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[400]!, Colors.green[700]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.menu_open, color: HexColor("#ffde59")),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 65),
                    child: Text(
                      "Game Lists",
                      style: TextStyle(
                          color: HexColor("#ffde59"),
                          fontFamily: 'Schyler',
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 6,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GameOption('Game')),
                      );
                    },
                    child: Card(
                      color: HexColor("#ffde59"),
                      child: ListTile(
                        title: Text(
                          'Quran Quiz',
                          style: TextStyle(
                            color: HexColor("#2a6e2d"),
                            fontSize: textFontSize,
                            fontFamily: 'Schyler',
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                              IconData(0x1F3C6, fontFamily: 'MaterialIcons')),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ScorecardGames('Quran Quiz'),
                                ));
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GameOption('Guess the Voice')),
                  );
                },
                child: Card(
                  color: HexColor("#ffde59"),
                  child: ListTile(
                    title: Text(
                      'Guess the Voice',
                      style: TextStyle(
                        color: HexColor("#2a6e2d"),
                        fontSize: textFontSize,
                        fontFamily: 'Schyler',
                      ),
                    ),
                    trailing: IconButton(
                        icon: const Icon(
                            IconData(0x1F3C6, fontFamily: 'MaterialIcons')),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ScorecardGames('Guess the Voice'),
                              ));
                        }),
                  ),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => JigsawScreen()),
                  );
                },
                child: Card(
                  color: HexColor("#ffde59"),
                  child: ListTile(
                    title: Text(
                      'Jigsaw Puzzle',
                      style: TextStyle(
                        color: HexColor("#2a6e2d"),
                        fontSize: textFontSize,
                        fontFamily: 'Schyler',
                      ),
                    ),
                    trailing: IconButton(
                        icon: const Icon(
                            IconData(0x1F3C6, fontFamily: 'MaterialIcons')),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ScorecardGames('Jigsaw Puzzles'),
                              ));
                        }),
                  ),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GuesstheMeaning()),
                  );
                },
                child: Card(
                  color: HexColor("#ffde59"),
                  child: ListTile(
                    title: Text(
                      'Guess the Meaning',
                      style: TextStyle(
                        color: HexColor("#2a6e2d"),
                        fontSize: textFontSize,
                        fontFamily: 'Schyler',
                      ),
                    ),
                    trailing: IconButton(
                        icon: const Icon(
                            IconData(0x1F3C6, fontFamily: 'MaterialIcons')),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ScorecardGames('Guess the Meaning'),
                              ));
                        }),
                  ),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WordPuzzleScreen()),
                  );
                },
                child: Card(
                  color: HexColor("#ffde59"),
                  child: ListTile(
                    title: Text(
                      'Guess the Words Puzzle',
                      style: TextStyle(
                        color: HexColor("#2a6e2d"),
                        fontSize: textFontSize,
                        fontFamily: 'Schyler',
                      ),
                    ),
                    trailing: IconButton(
                        icon: const Icon(
                            IconData(0x1F3C6, fontFamily: 'MaterialIcons')),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ScorecardGames('Search Words'),
                              ));
                        }),
                  ),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DragAndDrop()),
                  );
                },
                child: Card(
                  color: HexColor("#ffde59"),
                  child: ListTile(
                    title: Text(
                      'Drag And Drop',
                      style: TextStyle(
                        color: HexColor("#2a6e2d"),
                        fontSize: textFontSize,
                        fontFamily: 'Schyler',
                      ),
                    ),
                    trailing: IconButton(
                        icon: const Icon(
                            IconData(0x1F3C6, fontFamily: 'MaterialIcons')),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ScorecardGames('Drag and Drop'),
                              ));
                        }),
                  ),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WordleGame()),
                  );
                },
                child: Card(
                  color: HexColor("#ffde59"),
                  child: ListTile(
                    title: Text(
                      'Wordle',
                      style: TextStyle(
                        color: HexColor("#2a6e2d"),
                        fontSize: textFontSize,
                        fontFamily: 'Schyler',
                      ),
                    ),
                    trailing: IconButton(
                        icon: const Icon(
                            IconData(0x1F3C6, fontFamily: 'MaterialIcons')),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ScorecardGames('Wordle'),
                              ));
                        }),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
