import 'package:flutter/material.dart';
import 'dart:math';
import 'package:custom_timer/custom_timer.dart';
import 'package:qurankhwani/GameResult.dart';
import 'package:qurankhwani/homeScreen.dart';
import 'package:qurankhwani/main.dart';

class WordPuzzleScreen extends StatefulWidget {
  @override
  _WordPuzzleScreenState createState() => _WordPuzzleScreenState();
}

class _WordPuzzleScreenState extends State<WordPuzzleScreen>
    with TickerProviderStateMixin {
  late CustomTimerController _controller;
  late int gridSize;
  List<String> letters = [];
  List<bool> wordFound = [];
  late List<bool> highlighted;
  late List<bool> wordhighlighted;
  List<String> completedWords = [];

  @override
  void initState() {
    super.initState();
    _controller = CustomTimerController(
      vsync: this,
      begin: const Duration(seconds: 0),
      end: const Duration(hours: 2),
      initialState: CustomTimerState.reset,
      interval: CustomTimerInterval.milliseconds,
    );
    _controller.reset();
    _controller.start();
    gridSize = calculateGridSize();
    highlighted = List.filled(gridSize * gridSize, false);
    wordhighlighted = List.filled(gridSize * gridSize, false);
    wordFound = List.filled(wordsToFind.length, false);
    generateLetterGrid();
  }

  int calculateGridSize() {
    int maxLength = 0;
    for (String word in wordsToFind) {
      if (word.length > maxLength) {
        maxLength = word.length;
      }
    }
    return maxLength * 1 + 1;
  }

  void generateLetterGrid() {
    final random = Random();
    final List<List<String>> tempGrid = List.generate(
      gridSize,
      (index) => List.generate(gridSize, (index) => ''),
    );

    for (String word in wordsToFind) {
      bool placed = false;
      while (!placed) {
        int row = random.nextInt(gridSize);
        int col = random.nextInt(gridSize);
        int direction = random.nextInt(2); // 0 for horizontal, 1 for vertical
        if (direction == 0) {
          if (isWordPlaceable(word, tempGrid, row, col, 1, 0)) {
            placeWord(word, tempGrid, row, col, 1, 0);
            placed = true;
          }
        } else {
          if (isWordPlaceable(word, tempGrid, row, col, 0, 1)) {
            placeWord(word, tempGrid, row, col, 0, 1);
            placed = true;
          }
        }
      }
    }

    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        if (tempGrid[row][col] == '') {
          tempGrid[row][col] = String.fromCharCode(random.nextInt(26) + 65);
        }
      }
    }

    for (int row = 0; row < gridSize; row++) {
      letters.addAll(tempGrid[row]);
    }
  }

  bool isWordPlaceable(String word, List<List<String>> grid, int row, int col,
      int rowDelta, int colDelta) {
    int length = word.length;
    if (row + length * rowDelta >= gridSize ||
        col + length * colDelta >= gridSize) {
      return false;
    }
    for (int i = 0; i < length; i++) {
      if (grid[row + i * rowDelta][col + i * colDelta] != '') {
        return false;
      }
    }
    return true;
  }

  void placeWord(String word, List<List<String>> grid, int row, int col,
      int rowDelta, int colDelta) {
    int length = word.length;
    for (int i = 0; i < length; i++) {
      grid[row + i * rowDelta][col + i * colDelta] = word[i];
    }
  }

  @override
  void dispose() {
    // Dispose of your AnimationControllers
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search Words Puzzle'),
        ),
        body: (wordsToFind == [])
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      CustomTimer(
                          controller: _controller,
                          builder: (state, remaining) {
                            // Build the widget you want!
                            time =
                                "${remaining.hours}:${remaining.minutes}:${remaining.seconds}";
                            var orders = remaining.hours +
                                remaining.minutes +
                                remaining.seconds;
                            order = int.parse(orders);
                            return Text(
                                "${remaining.hours}:${remaining.minutes}:${remaining.seconds}",
                                style: const TextStyle(fontSize: 24.0));
                          }),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: gridSize,
                          ),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  highlighted[index] = !highlighted[index];
                                  wordhighlighted[index] =
                                      !wordhighlighted[index];
                                  checkWord();
                                });
                              },
                              child: Container(
                                color: highlighted[index]
                                    ? Colors.yellow
                                    : Colors.white,
                                child: Center(
                                  child: Text(
                                    letters[index],
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: gridSize * gridSize,
                        ),
                      ),
                      const Text(
                        'Words to Find',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Expanded(
                        child: ListView.builder(
                          itemCount: wordsToFind.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                wordsToFind[index] +
                                    "  (" +
                                    ArabicWordsToFind[index] +
                                    ")",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: wordFound[index]
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: wordFound[index]
                                      ? Colors.green
                                      : Colors.black,
                                ),
                              ),
                              trailing: wordFound[index]
                                  ? const Icon(Icons.check, color: Colors.green)
                                  : null,
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                var rng = Random();
                                setState(() {
                                  wordsToFind.clear();
                                  ArabicWordsToFind.clear();
                                  var previous = [];
                                  var int;
                                  for (var i = 0; i < 5; i++) {
                                    do {
                                      int = rng.nextInt(49);
                                    } while (previous.contains(int));
                                    previous.add(int);
                                    wordsToFind.add(wordsToFindrange[int]);
                                    ArabicWordsToFind.add(
                                        ArabicWordsToFindrange[int]);
                                  }
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              super.widget));
                                });
                              },
                              child: const Text('Regenerate')),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                _controller.pause();
                              },
                              child: const Text('Pause')),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                _controller.start();
                              },
                              child: const Text('Start')),
                        ],
                      )
                    ],
                  ),
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            solvePuzzle();

            ///  _controller.dispose();
            var point = 0;
            if (order < 59) {
              point = 5;
            } else if (order < 159 && order > 59) {
              point = 4;
            } else if (order < 259 && order > 159) {
              point = 3;
            } else if (order < 359 && order > 259) {
              point = 2;
            } else {
              point = 1;
            }
          },
          child: const Icon(Icons.lightbulb),
        ),
      ),
    );
  }

  void solvePuzzle() {
    setState(() {
      highlighted = List.filled(gridSize * gridSize, false);
      completedWords.clear();
      for (int i = 0; i < wordsToFind.length; i++) {
        String word = wordsToFind[i];
        if (highlightWord(word)) {
          wordFound[i] = true;
          completedWords.add(word);
        }
      }
    });
  }

  void checkWord() {
    String selectedWord = '';
    for (int i = 0; i < wordhighlighted.length; i++) {
      if (wordhighlighted[i]) {
        selectedWord += letters[i];
      }
    }
    if (selectedWord.isNotEmpty) {
      if (completedWords.contains(selectedWord)) {
        // Word already completed
        return;
      }
      if (wordsToFind.contains(selectedWord)) {
        // Valid word found
        int index = wordsToFind.indexOf(selectedWord);
        setState(() {
          print('Word completed: $selectedWord');
          wordFound[index] = true;
          completedWords.add(selectedWord);
          wordhighlighted = List.filled(gridSize * gridSize, false);
        });
      }
      if (completedWords.length == wordsToFind.length) {
        // All words found, navigate to the next page
        _controller.pause(); // Stop the timer before navigation
        var point = 0;
        if (order < 59) {
          point = 5;
        } else if (order < 159 && order > 59) {
          point = 4;
        } else if (order < 259 && order > 159) {
          point = 3;
        } else if (order < 359 && order > 259) {
          point = 2;
        } else {
          point = 1;
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => GameResult('Search Words', time, point)),
        );
      }
    }
  }

  bool highlightWord(String word) {
    final List<int> wordIndices = [];
    for (int i = 0; i < letters.length; i++) {
      if (letters[i] == word[0]) {
        wordIndices.add(i);
      }
    }

    final List<List<int>> directions = [
      [1, 0], // Right
      [1, 1], // Right-Down
      [0, 1], // Down
      [-1, 1], // Left-Down
    ];

    for (int index in wordIndices) {
      for (var direction in directions) {
        int row = index ~/ gridSize;
        int col = index % gridSize;
        bool found = true;
        for (int i = 1; i < word.length; i++) {
          row += direction[0];
          col += direction[1];
          if (row < 0 ||
              row >= gridSize ||
              col < 0 ||
              col >= gridSize ||
              letters[row * gridSize + col] != word[i]) {
            found = false;
            break;
          }
        }
        if (found) {
          for (int i = 0; i < word.length; i++) {
            int highlightIndex =
                index + (i * direction[0] * gridSize) + (i * direction[1]);
            highlighted[highlightIndex] = true;
          }
          return true;
        }
      }
    }
    return false;
  }
}
