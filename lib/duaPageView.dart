import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qurankhwani/main.dart';

class DuasPageView extends StatefulWidget {
  var duaNo;
  var duaName;
  DuasPageView(this.duaName, this.duaNo);

  @override
  State<DuasPageView> createState() => _DuasPageViewState();
}

class _DuasPageViewState extends State<DuasPageView> {
  late LongPressGestureRecognizer _tapGestureRecognizer;
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
                    widget.duaName,
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
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: HexColor("#2a6e2d"),
                                  width: 5, // red as border color
                                ),
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FutureBuilder(
                                      future: FirebaseFirestore.instance
                                          .collection("Duas")
                                          .where("duaNo",
                                              isEqualTo:
                                                  int.parse(widget.duaNo))
                                          .get(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (!snapshot.hasData) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        print(snapshot.data?.docs.length);
                                        return ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:
                                                snapshot.data?.docs.length,
                                            itemBuilder: (context, index) {
                                              QueryDocumentSnapshot<Object?>?
                                                  ds =
                                                  snapshot.data?.docs[index];
                                              String duaText = ds![
                                                  "arabicTextWithWordsMeaning"];
                                              String meaning = ds['Meaning'];

                                              RegExp arabicRegex = RegExp(
                                                  r'[\u0600-\u06FF]+'); // Matches Arabic characters and spaces
                                              var englishRegex = duaText.replaceAll(
                                                  RegExp(r'[\u0600-\u06FF]+'),
                                                  ','); // Matches English letters and spaces
                                              var englishArray =
                                                  englishRegex.split(',');
                                              print(englishRegex);
                                              var arabicArray = arabicRegex
                                                  .allMatches(duaText)
                                                  .map(
                                                      (match) => match.group(0))
                                                  .toList();
                                              print(arabicArray);

                                              List<List<TextSpan>>
                                                  rowsChildrens = [];
                                              List<TextSpan> rowChildren = [];
                                              for (var i = 0;
                                                  i < arabicArray.length;
                                                  i++) {
                                                _tapGestureRecognizer =
                                                    LongPressGestureRecognizer();
                                                _tapGestureRecognizer
                                                    .onLongPress = () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          scrollable: true,
                                                          title: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                arabicArray[i]
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        56,
                                                                    fontFamily:
                                                                        'Al Qalam Quran'),
                                                              )),
                                                          content: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                englishArray[
                                                                        i + 1]
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              )),
                                                        );
                                                      });
                                                };
                                                rowChildren.add(TextSpan(
                                                    text: arabicArray[i]
                                                            .toString() +
                                                        ' ',
                                                    recognizer:
                                                        _tapGestureRecognizer));
                                              }
                                              rowChildren.add(TextSpan(
                                                  text: "\n\n\n\n" + meaning));
                                              rowsChildrens.add(rowChildren);

                                              return Column(
                                                children: rowsChildrens
                                                    .map<Widget>(
                                                        (rowChildren) =>
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 10),
                                                              child: RichText(
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  text:
                                                                      TextSpan(
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Al Qalam Quran',
                                                                      color: HexColor(
                                                                          "#2a6e2d"),
                                                                      fontSize:
                                                                          arabictextFontSize,
                                                                    ), //ArabicFonts.amiri(textStyle: display1),),
                                                                    children:
                                                                        rowChildren,
                                                                  )),
                                                            ))
                                                    .toList(),
                                              );
                                            });
                                      })),
                            )))),
              ]))),
    );
  }
}
