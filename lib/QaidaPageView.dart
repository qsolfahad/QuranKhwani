import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:qurankhwani/main.dart';
import 'package:qurankhwani/homeScreen.dart' as data;

class QaidaPageView extends StatefulWidget {
  var index;

  QaidaPageView(this.index);

  @override
  State<QaidaPageView> createState() => _QaidaPageViewState();
}

class _QaidaPageViewState extends State<QaidaPageView> {
  var flg = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green[400]!, Colors.green[700]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: Text(
                    'Lesson no ' + widget.index.toString(),
                    style: TextStyle(
                        color: HexColor("#ffde59"),
                        fontFamily: 'Schyler',
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                    child: InteractiveViewer(
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              height: MediaQuery.of(context).size.longestSide,
                              width: MediaQuery.of(context).size.longestSide,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: HexColor("#2a6e2d"),
                                  width: 5, // red as border color
                                ),
                              ),
                              child: SingleChildScrollView(
                                  child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(
                                          data.rowlenght[widget.index]!,
                                          (indexC) => Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children:
                                                List.generate(3, (indexR) {
                                              var c = indexC + 1;
                                              var r = indexR + 1;
                                              var value = data.elements[
                                                      widget.index.toString() +
                                                          ',' +
                                                          c.toString()]![
                                                      widget.index.toString() +
                                                          ',' +
                                                          r.toString()]
                                                  .toString();
                                              List<String>? valueSplit;
                                              var splitFlag = true;
                                              print(data.record[widget.index
                                                              .toString() +
                                                          ',' +
                                                          c.toString()]
                                                      .toString() +
                                                  value);
                                              if (data.record[widget.index
                                                              .toString() +
                                                          ',' +
                                                          c.toString()] ==
                                                      290 ||
                                                  value == 'هَ ل' ||
                                                  data.record[widget.index
                                                              .toString() +
                                                          ',' +
                                                          c.toString()] ==
                                                      380) {
                                                splitFlag = false;
                                                valueSplit = value.split(' ');
                                              }
                                              if (data.section[
                                                      widget.index.toString() +
                                                          ',' +
                                                          c.toString()] ==
                                                  'word') flg++;
                                              if ((data.elements[widget.index
                                                              .toString() +
                                                          ',' +
                                                          c.toString()]![widget
                                                              .index
                                                              .toString() +
                                                          ',' +
                                                          r.toString()] !=
                                                      null) &&
                                                  (data.elements[widget.index
                                                              .toString() +
                                                          ',' +
                                                          c.toString()]![widget
                                                              .index
                                                              .toString() +
                                                          ',' +
                                                          r.toString()] !=
                                                      '')) {
                                                if (data.section[widget.index
                                                                .toString() +
                                                            ',' +
                                                            c.toString()] ==
                                                        'word' &&
                                                    (flg == 1 ||
                                                        flg == 2 ||
                                                        flg == 3) &&
                                                    c != 1) {
                                                  return Column(
                                                    children: [
                                                      const SizedBox(
                                                        height: 50,
                                                      ),
                                                      Container(
                                                        child: Text(
                                                          'Words ',
                                                          style: TextStyle(
                                                              color: HexColor(
                                                                  "#ffde59"),
                                                              fontFamily:
                                                                  'Schyler',
                                                              fontSize: 30,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Card(
                                                          elevation: 3,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () async {
                                                              FlutterTts tts =
                                                                  FlutterTts();
                                                              tts.setLanguage(
                                                                  "ar-SA");
                                                              if (data.elements[widget
                                                                              .index
                                                                              .toString() +
                                                                          ',' +
                                                                          c.toString()]![widget
                                                                              .index
                                                                              .toString() +
                                                                          ',' +
                                                                          r.toString()]
                                                                      .toString() ==
                                                                  'ے') {
                                                                tts.speak('Ya');
                                                              } else {
                                                                tts.speak(data
                                                                    .meanings[widget
                                                                            .index
                                                                            .toString() +
                                                                        ',' +
                                                                        c.toString()]![widget
                                                                            .index
                                                                            .toString() +
                                                                        ',' +
                                                                        r.toString()]
                                                                    .toString());
                                                              }
                                                            },
                                                            child: Container(
                                                              //width: MediaQuery.of(context).size.width/8.6,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  3.9,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            60),
                                                              ),
                                                              child: Column(
                                                                children: [
                                                                  if (splitFlag ==
                                                                      true)
                                                                    Center(
                                                                        child:
                                                                            Text(
                                                                      value,
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              36,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    )),
                                                                  if (splitFlag ==
                                                                      false)
                                                                    Row(
                                                                      children: [
                                                                        if (splitFlag ==
                                                                            true)
                                                                          Center(
                                                                              child: Text(
                                                                            value,
                                                                            style:
                                                                                const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                                                                          )),
                                                                        if (splitFlag ==
                                                                            false)
                                                                          RichText(
                                                                            text:
                                                                                TextSpan(
                                                                              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                                                                              children: <TextSpan>[
                                                                                if (value != 'هَ ل')
                                                                                  TextSpan(
                                                                                    text: valueSplit![0],
                                                                                    style: const TextStyle(color: Colors.white),
                                                                                  ),
                                                                                if (value != 'هَ ل')
                                                                                  TextSpan(
                                                                                    text: valueSplit![1],
                                                                                    style: const TextStyle(color: Colors.black),
                                                                                  ),
                                                                                if (value == 'هَ ل')
                                                                                  TextSpan(
                                                                                    text: valueSplit![0],
                                                                                    style: const TextStyle(color: Colors.black),
                                                                                  ),
                                                                                if (value == 'هَ ل')
                                                                                  TextSpan(
                                                                                    text: valueSplit![1],
                                                                                    style: const TextStyle(color: Colors.white),
                                                                                  ),

                                                                                // continue adding TextSpans for each letter in the text
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        Center(
                                                                            child:
                                                                                Text(
                                                                          data.EnglishMeanings[widget.index.toString() + ',' + c.toString()]![widget.index.toString() + ',' + r.toString()]
                                                                              .toString(),
                                                                          style: const TextStyle(
                                                                              fontSize: 16,
                                                                              color: Colors.grey),
                                                                        )),
                                                                      ],
                                                                    ),
                                                                  Center(
                                                                      child:
                                                                          Text(
                                                                    data.EnglishMeanings[widget.index.toString() +
                                                                            ',' +
                                                                            c.toString()]![widget.index
                                                                                .toString() +
                                                                            ',' +
                                                                            r.toString()]
                                                                        .toString(),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Colors
                                                                            .grey),
                                                                  )),
                                                                ],
                                                              ),
                                                            ),
                                                          ))
                                                    ],
                                                  );
                                                }

                                                return Card(
                                                    elevation: 3,
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        FlutterTts tts =
                                                            FlutterTts();
                                                        var isLanguageAvailable =
                                                            await tts
                                                                .getLanguages;
                                                        print(
                                                            isLanguageAvailable);

                                                        tts.setLanguage(
                                                            "ar-PK");
                                                        if (data.elements[widget
                                                                        .index
                                                                        .toString() +
                                                                    ',' +
                                                                    c.toString()]![widget
                                                                        .index
                                                                        .toString() +
                                                                    ',' +
                                                                    r.toString()]
                                                                .toString() ==
                                                            'ے') {
                                                          tts.speak('Ya');
                                                        } else {
                                                          tts.speak(data
                                                              .meanings[widget
                                                                      .index
                                                                      .toString() +
                                                                  ',' +
                                                                  c.toString()]![widget
                                                                      .index
                                                                      .toString() +
                                                                  ',' +
                                                                  r.toString()]
                                                              .toString());
                                                        }
                                                      },
                                                      child: Container(
                                                        //width: MediaQuery.of(context).size.width/8.6,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3.9,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(60),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            if (splitFlag ==
                                                                true)
                                                              Center(
                                                                  child: Text(
                                                                value,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        36,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )),
                                                            if (splitFlag ==
                                                                false)
                                                              RichText(
                                                                text: TextSpan(
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          36,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  children: <
                                                                      TextSpan>[
                                                                    if (value !=
                                                                        'هَ ل')
                                                                      TextSpan(
                                                                        text: valueSplit![
                                                                            0],
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    if (value !=
                                                                        'هَ ل')
                                                                      TextSpan(
                                                                        text: valueSplit![
                                                                            1],
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    if (value ==
                                                                        'هَ ل')
                                                                      TextSpan(
                                                                        text: valueSplit![
                                                                            0],
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    if (value ==
                                                                        'هَ ل')
                                                                      TextSpan(
                                                                        text: valueSplit![
                                                                            1],
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      ),

                                                                    // continue adding TextSpans for each letter in the text
                                                                  ],
                                                                ),
                                                              ),
                                                            Center(
                                                                child: Text(
                                                              data.EnglishMeanings[widget
                                                                          .index
                                                                          .toString() +
                                                                      ',' +
                                                                      c.toString()]![widget
                                                                          .index
                                                                          .toString() +
                                                                      ',' +
                                                                      r.toString()]
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .grey),
                                                            )),
                                                          ],
                                                        ),
                                                      ),
                                                    ));
                                              } else {
                                                return SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3.9,
                                                );
                                              }
                                            }),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      'Instruction',
                                      style: TextStyle(
                                          color: HexColor("#ffde59"),
                                          fontFamily: 'Schyler',
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          data.instruction[widget.index]
                                              .toString()
                                              .replaceAll(' ', '  '),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: textFontSize,
                                            fontFamily: 'Al Qalam Quran',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                            )))),
              ]))),
    );
  }
}
