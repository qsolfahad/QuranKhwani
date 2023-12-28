import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:qurankhwani/GameResult.dart';
import 'package:qurankhwani/main.dart';
import 'package:hexcolor/hexcolor.dart';

class DataModel {
  String? imagePath;
  int number;
  DataModel? dataModel;

  DataModel({
    this.imagePath,
    required this.number,
    this.dataModel,
  });
}

class PuzzleGame extends StatefulWidget {
  const PuzzleGame({
    Key? key,
  });

  @override
  State<PuzzleGame> createState() => _PuzzleGameState();
}

class _PuzzleGameState extends State<PuzzleGame> with TickerProviderStateMixin {
  late CustomTimerController _controller;
  List<DataModel> dataModel = [];
  List<DataModel> dataModel2 = [];
  int rows = 5, columns = 5;

  void _initializeDataModels() {
    for (var i = 1; i <= rows * columns; i++) {
      dataModel.add(DataModel(number: i));
    }
  }

  @override
  void initState() {
    super.initState();

    _initializeDataModels();
    for (var model in dataModel) {
      dataModel2.add(DataModel(number: model.number));
    }
    dataModel2.shuffle();

    _controller = CustomTimerController(
      vsync: this,
      begin: const Duration(seconds: 0),
      end: const Duration(hours: 2),
      initialState: CustomTimerState.reset,
      interval: CustomTimerInterval.milliseconds,
    );
    _controller.reset();
    _controller.start();
  }

  bool isPuzzleComplete() {
    for (var model in dataModel) {
      if (model.dataModel == null) {
        return false;
      }
    }
    return true;
  }

  void _showCongratulationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You have completed the puzzle.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, textStyle: const TextStyle(fontSize: 16));
    return SafeArea(
      child: Scaffold(
          body: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 20),
              child: Text(
                'Jigsaw Puzzle',
                style: TextStyle(fontSize: 36),
              ),
            ),
            CustomTimer(
                controller: _controller,
                builder: (state, remaining) {
                  // Build the widget you want!
                  time =
                      "${remaining.hours}:${remaining.minutes}:${remaining.seconds}";
                  var orders =
                      remaining.hours + remaining.minutes + remaining.seconds;
                  order = int.parse(orders);
                  return Text(
                      "${remaining.hours}:${remaining.minutes}:${remaining.seconds}",
                      style: const TextStyle(fontSize: 24.0));
                }),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  itemCount: dataModel.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: rows,
                    mainAxisSpacing: 0.5,
                    crossAxisSpacing: 0.5,
                  ),
                  itemBuilder: (context, index) {
                    return Center(
                      child: DragTarget<DataModel>(
                        builder: (BuildContext context,
                            List<Object?> candidateData,
                            List<dynamic> rejectedData) {
                          return Container(
                            color: dataModel[index].dataModel == null
                                ? Colors.grey
                                : Colors.white,
                            child: Center(
                              child: dataModel[index].dataModel == null
                                  ? Container()
                                  : Image.asset(
                                      'assets/image/jigsaw/${dataModel[index].number}.png',
                                      width: 80,
                                      height: 80,
                                    ),
                            ),
                          );
                        },
                        onAccept: (data) {
                          setState(() {
                            if (data.number == dataModel[index].number) {
                              dataModel[index].dataModel = data;
                              dataModel2.remove(data);
                              data.imagePath =
                                  ''; // Clear the imagePath so it can't be dropped again
                              if (isPuzzleComplete()) {
                                _controller.reset();
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
                                      builder: (context) => GameResult(
                                          'Jigsaw Puzzles', time, point)),
                                );
                              }
                            }
                          });
                        },
                        onWillAccept: (data) {
                          return data?.number == dataModel[index].number;
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            Expanded(
              child: SizedBox(
                height: 200,
                child: CarouselSlider.builder(
                  itemCount: dataModel2.length,
                  options: CarouselOptions(
                    height: 100,
                    enableInfiniteScroll: false,
                    aspectRatio: 5.0,
                    viewportFraction: 0.6,
                  ),
                  itemBuilder:
                      (BuildContext context, int index, int realIndex) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Draggable<DataModel>(
                        data: dataModel2[index],
                        feedback: Material(
                          child: Image.asset(
                            'assets/image/jigsaw/${dataModel2[index].number}.png',
                            width: 80,
                            height: 80,
                          ),
                        ),
                        childWhenDragging: Container(),
                        child: Image.asset(
                          'assets/image/jigsaw/${dataModel2[index].number}.png',
                          width: 80,
                          height: 80,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: style,
                  onPressed: () async {
                    _controller.reset();
                    _controller.start();
                  },
                  child: const Text('Generate'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  style: style,
                  onPressed: () {
                    _controller.pause();
                  },
                  child: const Text('Pause'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  style: style,
                  onPressed: () {
                    _controller.reset();
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
