import 'dart:math';
import 'package:qurankhwani/GameOptionPage.dart' as val;
import 'package:flutter/material.dart';
import 'package:qurankhwani/GameResult.dart';
import 'package:qurankhwani/homeScreen.dart';

class WordleGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WordleScreen();
  }
}

class WordleScreen extends StatefulWidget {
  @override
  _WordleScreenState createState() => _WordleScreenState();
}

class _WordleScreenState extends State<WordleScreen> {
  final myController = TextEditingController();

  Wordle currentDua = Wordle(arabic: "", meaning: "");
  List<String> jumbledArabicLetters = [];
  List<String> checkLetterColor = [];
  int colorCount = -1;
  String guessedMeaning = '';
  String guessedArabic = '';
  String feedbackMessage = '';
  dynamic remainingAttempts = 5;

  @override
  void initState() {
    super.initState();
    chooseRandomDua();
  }

  void chooseRandomDua() {
    myController.clear();
    Random random = Random();
    int randomNumber = random.nextInt(wordle.length);

    setState(() {
      currentDua = wordle[randomNumber];
      guessedMeaning = '';
      colorCount = -1;
      guessedArabic = '_ ' * currentDua.arabic.length;
      feedbackMessage = '';
      remainingAttempts = 5;

      jumbledArabicLetters.clear();
      checkLetterColor.clear();
      String jumbleLetters = jumbleWord(currentDua.meaning);
      for (int i = 0; i < jumbleLetters.length; i++) {
        if (currentDua.meaning[i] == jumbleLetters[i]) {
          checkLetterColor.add('green');
        } else {
          checkLetterColor.add('black');
        }
        jumbledArabicLetters.add(jumbleLetters[i].toUpperCase());
      }
    });
  }

  String jumbleWord(String word) {
    List<String> characters = word.split('');
    characters.shuffle();
    return characters.join();
  }

  void checkAnswer() {
    print(myController.text.toLowerCase());
    setState(() {
      colorCount = -1;
      print(myController.text.toLowerCase() +
          currentDua.meaning.toLowerCase().trim());
      if (myController.text.toLowerCase().trim() ==
          currentDua.meaning.toLowerCase().trim()) {
        guessedArabic = currentDua.arabic;
        feedbackMessage =
            'Correct! The Arabic Meaning is: ${currentDua.meaning.toLowerCase().trim()}';
        val.result = remainingAttempts;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GameResult('Wordle', 0, 0)),
        );
      } else {
        feedbackMessage = 'Incorrect. Keep trying!';
      }

      remainingAttempts--;

      if (remainingAttempts == 0) {
        // Close the game or navigate back
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GameResult('Wordle', 0, 0)),
        );
      }
    });
  }

  void guessLetter(String letter) {
    setState(() {
      colorCount = -1;
      bool correctGuess = false;
      String newGuessedArabic = '';
      print(letter);
      if (letter == '|') {
        myController.text =
            myController.text.substring(0, myController.text.length - 1);
      } else {
        myController.text += letter;
      }
      for (int i = 0; i < currentDua.meaning.length; i++) {
        if (currentDua.meaning[i] == letter) {
          newGuessedArabic += letter + ' ';
          correctGuess = true;
        } else {
          newGuessedArabic += guessedArabic.split(' ')[i] + ' ';
        }
      }

      guessedArabic = newGuessedArabic;

      if (!guessedArabic.contains('_')) {
        myController.text = currentDua.meaning;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Wordle Game'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  currentDua.arabic,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(
                    28,
                    (index) => GestureDetector(
                      onTap: () => (String.fromCharCode(97 + index) == '{')
                          ? guessLetter(' ')
                          : (String.fromCharCode(97 + index) == '|')
                              ? guessLetter(String.fromCharCode(97 + index))
                              : guessLetter(String.fromCharCode(97 + index)),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: (String.fromCharCode(97 + index) == '{')
                            ? const Text(
                                'Space',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              )
                            : (String.fromCharCode(97 + index) == '|')
                                ? const Text(
                                    '<',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  )
                                : Text(
                                    String.fromCharCode(97 + index),
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Guess the English Meaning:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: myController,
                  decoration:
                      const InputDecoration(labelText: 'Enter meaning here'),
                  // onChanged: (value) {
                  //   //  guessedMeaning = value;
                  //   myController.text = value;
                  // },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: checkAnswer,
                child: const Text('Check Answer'),
              ),
              const SizedBox(height: 16),
              if (remainingAttempts > 0)
                Text(
                  'Attempts remaining: $remainingAttempts',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              if (remainingAttempts == 0)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Out of attempts! Game over.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Jumbled Meaning Words:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      children: jumbledArabicLetters.map((jumbledWord) {
                        colorCount++;
                        return Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom:
                                  BorderSide(width: 1.0, color: Colors.black),
                            ),
                          ),
                          child: Text(
                            jumbledWord,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: (checkLetterColor[colorCount] == 'green')
                                    ? Colors.green
                                    : Colors.black),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              if (feedbackMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    feedbackMessage,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: chooseRandomDua,
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}
