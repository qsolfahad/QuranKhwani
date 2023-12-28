import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:qurankhwani/RecordPage.dart';
import 'package:qurankhwani/bookmark_page.dart';
import 'package:qurankhwani/group_screen.dart';
import 'package:qurankhwani/homeScreen.dart';
import 'package:qurankhwani/intro_name.dart';
import 'package:qurankhwani/juzLists.dart';
import 'package:qurankhwani/main.dart';
import 'package:qurankhwani/pageRoute.dart';
//import 'package:google_fonts_arabic/fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qurankhwani/homeScreen.dart' as list;
import 'package:flutter/gestures.dart';

class JuzPageView extends StatefulWidget {
  var juzName;
  var juzAyah;
  var juzNo;
  var juzPage;
  var juzEndPage;

  int currVal;
  Color color;

  var surahno;
  JuzPageView(this.juzName, this.juzNo, this.juzAyah, this.juzPage,
      this.juzEndPage, this.surahno, this.currVal, this.color);
  @override
  State<JuzPageView> createState() => _JuzPageViewState();
}

class _JuzPageViewState extends State<JuzPageView> {
  var val;
  var sub;
  final _formKey = GlobalKey<FormState>();
  var _selectedIndex = 1;
  late LongPressGestureRecognizer _tapGestureRecognizer;
  List<String> quranWordsMeaning = [];
  Set<String> uniqueWords = Set();
  // late Timer _timer;
// @override
// void dispose() {
//   if (_timer != null) {
//     _timer.cancel();
//   }
//   super.dispose();
// }

  Future<void> _addbookmark(juzNo, pageNo, surahno, verseNo, pos) async {
    try {
      var flag = true;
      var value = await FirebaseAuth.instance.signInAnonymously();
      var bookmarkdb = FirebaseFirestore.instance.collection("Bookmarks");
      sub = bookmarkdb
          .where("userId", isEqualTo: value.user!.uid)
          .where("pageNo", isEqualTo: pageNo)
          .where("verseno", isEqualTo: verseNo)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          print("working");

          _showMessageInScaffold("Already Added bookmark");
          flag = false;
          print("The state: " + flag.toString());
        } else {
          print("Added");
          bookmarkdb.add({
            "userId": value.user!.uid,
            "createdDate": DateTime.now(),
            'state': 'Juz',
            'juzName': widget.juzName,
            'verseno': verseNo,
            'startVerseNo': widget.juzPage,
            'surahNo': surahno.toString(),
            'juzNo': juzNo,
            'pageNo': pageNo,
            'position': pos,
            'endVerseNo': widget.juzEndPage
          });
          _showMessageInScaffold("Added bookmark");
          sub.cancel();
        }
      });
    } catch (e) {
      print(e); // TODO: show dialog with error
    }
  }

  void _showMessageInScaffold(String message) {
    try {
      final snackBar = SnackBar(
        content: Text(message),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on Exception catch (e, s) {
      print(s);
    }
  }

  void updateCounter() async {
    var uservalue = await FirebaseAuth.instance.signInAnonymously();
    await FirebaseFirestore.instance
        .collection("UserRecord")
        .where("UserId", isEqualTo: uservalue.user?.uid)
        .where("name", isEqualTo: 'juz')
        .get()
        .then((value) => value.docs.forEach((element) {
              FirebaseFirestore.instance
                  .collection("UserRecord")
                  .doc(element.id)
                  .update({
                "${widget.juzName}": element.data()[widget.juzName] + 1
              });
              list.JuzCount[widget.juzName] =
                  element.data()[widget.juzName] + 1;
            }));
  }

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const MyHomePage(
                  title: 'Quran Khwani',
                )),
      );
    }
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PageRouteJuzScreen()),
      );
    }

    if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RecordJuzPage()),
      );
    }
    if (index == 3) {
      var uservalue = await FirebaseAuth.instance.signInAnonymously();
      var check = 0;
      var data = await FirebaseFirestore.instance
          .collection("Users")
          .where("userID", isEqualTo: uservalue.user?.uid)
          .get()
          .then((value) => check = value.size);
      if (check == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => IntroName('grp')),
        );
      } else {
        var uservalue = await FirebaseAuth.instance.signInAnonymously();
        var check = 0;
        var data = await FirebaseFirestore.instance
            .collection("Users")
            .where("userID", isEqualTo: uservalue.user?.uid)
            .get()
            .then((value) => check = value.size);
        if (check == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => IntroName('grp')),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GroupScreen(false)),
          );
        }
      }
    }
    if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BookmarkPage()),
      );
    }
  }

  addActivities(surahname) async {
    var value = await FirebaseAuth.instance.signInAnonymously();
    FirebaseFirestore.instance
        .collection("Request")
        .where('userID', isEqualTo: value.user?.uid)
        .get()
        .then((value) => value.docs.forEach((element) {
              if (element.data()['userName'] == '') {
                FirebaseFirestore.instance.collection("Activities").add({
                  'groupID': element.data()['groupID'],
                  'description':
                      'Juz ' + surahname + ' is Completed by ' + 'anonymous',
                  'createdDate': DateTime.now(),
                });
              } else {
                FirebaseFirestore.instance.collection("Activities").add({
                  'groupID': element.data()['groupID'],
                  'description': 'Juz ' +
                      surahname +
                      ' is Completed by ' +
                      element.data()['userName'],
                  'createdDate': DateTime.now(),
                });
              }
            }));
  }

  void lastview(pos) async {
    var value = await FirebaseAuth.instance.signInAnonymously();
    FirebaseFirestore.instance.collection("ListView").add({
      "userId": value.user?.uid,
      "currentPosition": pos,
      "surahName": widget.juzName,
      "surahNo": widget.juzNo,
      "surahAyah": widget.juzAyah,
      "surahPage": widget.juzPage,
      "surahEndPage": widget.juzEndPage,
      "createdDate": DateTime.now(),
    });
  }

  String convertToArabicNumber(String number) {
    String res = '';

    final arabics = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    for (var element in number.characters) {
      res += arabics[int.parse(element)];
    }

/*   final latins = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']; */
    return res;
  }

  @override
  void initState() {
    val = int.parse(widget.juzEndPage) - int.parse(widget.juzPage) + 1;
    print(val.toString());
    super.initState();
  }

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
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                child: Text(
                  widget.juzName,
                  style: TextStyle(
                      color: HexColor("#ffde59"),
                      fontFamily: 'Schyler',
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: InteractiveViewer(
                  child: PageView.builder(
                      reverse: true,
                      controller: PageController(
                          initialPage: widget.currVal,
                          keepPage: true,
                          viewportFraction: 1),
                      itemCount: val,
                      itemBuilder: (context, position) {
                        var flg = true;
                        lastview(position);
                        return Padding(
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
                                    .collection("Ayahs")
                                    .where("juzNo", isEqualTo: widget.juzNo)
                                    .where("pageNo",
                                        isEqualTo: (int.parse(widget.juzPage) +
                                                position)
                                            .toString())
                                    .orderBy("totalverse")
                                    .get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  List<TextSpan> rowChildren = [];
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data?.docs.length,
                                      itemBuilder: (context, index) {
                                        QueryDocumentSnapshot<Object?>? ds =
                                            snapshot.data?.docs[index];
                                        String verseget = ds!["verse"];
                                        int verseNo = ds["verseNo"];
                                        String ArabicNo = convertToArabicNumber(
                                            ds["verseNo"].toString());
                                        String juzNo = ds["juzNo"];
                                        int Nisf = ds["Nisf"];
                                        int ruba = ds["ruba"];
                                        int salasat = ds["Salasat"];
                                        String pageNo = ds["pageNo"];
                                        String surahNames = ds['surahName'];
                                        var surahNo = ds['surahNo'];
                                        List<List<TextSpan>> rowsChildrens = [];
                                        //print(snapshot.data?.docs.length);
                                        final display1 = Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .copyWith(
                                              color: HexColor("#2a6e2d"),
                                              fontSize: arabictextFontSize,
                                            );

                                        if (verseNo != 0) {
                                          var splitverse = verseget.split(' ');
                                          //  print(splitverse);
                                          for (var i = 0;
                                              i < splitverse.length;
                                              i++) {
                                            _tapGestureRecognizer =
                                                LongPressGestureRecognizer();
                                            _tapGestureRecognizer.onLongPress =
                                                () async {
                                              quranWordsMeaning.clear();
                                              uniqueWords.clear();
                                              await FirebaseFirestore.instance
                                                  .collection('QuranWords')
                                                  .where('Surah',
                                                      isEqualTo:
                                                          int.parse(surahNo))
                                                  .where('Ayah',
                                                      isEqualTo:
                                                          (surahNo == "9")
                                                              ? verseNo
                                                              : verseNo + 1)
                                                  .get()
                                                  .then((value) => value.docs
                                                          .forEach((element) {
                                                        print('in');
                                                        if (!uniqueWords
                                                            .contains(element
                                                                .data()[
                                                                    'Record Number']
                                                                .toString())) {
                                                          uniqueWords.add(element
                                                              .data()[
                                                                  'Record Number']
                                                              .toString());
                                                          quranWordsMeaning.add((element
                                                                      .data()[
                                                                          'Record Number']
                                                                      .toString() +
                                                                  "|" +
                                                                  element.data()[
                                                                      'Words'] +
                                                                  "|" +
                                                                  element.data()[
                                                                      'Meaning'])
                                                              .trim());
                                                        }
                                                      }));

                                              quranWordsMeaning.sort((a, b) {
                                                int recordNumberA =
                                                    int.parse(a.split('|')[0]);
                                                int recordNumberB =
                                                    int.parse(b.split('|')[0]);

                                                return recordNumberA
                                                    .compareTo(recordNumberB);
                                              });
                                              String word = quranWordsMeaning[i]
                                                  .split("|")[1];
                                              String wordMeaning =
                                                  quranWordsMeaning[i]
                                                      .split("|")[2];
                                              print('press' +
                                                  word +
                                                  wordMeaning +
                                                  i.toString());
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      scrollable: true,
                                                      title:
                                                          const Text("Options"),
                                                      content: Column(
                                                        children: [
                                                          ListTile(
                                                              title: const Text(
                                                                  'Add Bookmark'),
                                                              trailing:
                                                                  const Icon(Icons
                                                                      .bookmark),
                                                              onTap: () {
                                                                _addbookmark(
                                                                    juzNo
                                                                        .toString(),
                                                                    pageNo
                                                                        .toString(),
                                                                    surahNo
                                                                        .toString(),
                                                                    verseNo
                                                                        .toString(),
                                                                    position);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              }),
                                                          const Divider(),
                                                          ListTile(
                                                              title: const Text(
                                                                  'Show Word Content'),
                                                              trailing:
                                                                  const Icon(Icons
                                                                      .contact_page_outlined),
                                                              onTap: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return AlertDialog(
                                                                        scrollable:
                                                                            true,
                                                                        title: Align(
                                                                            alignment: Alignment.center,
                                                                            child: Text(
                                                                              word.toString(),
                                                                              style: const TextStyle(fontSize: 56, fontFamily: 'Al Qalam Quran'),
                                                                            )),
                                                                        content: Align(
                                                                            alignment: Alignment.center,
                                                                            child: Text(
                                                                              wordMeaning.toString(),
                                                                              style: const TextStyle(color: Colors.grey),
                                                                            )),
                                                                      );
                                                                    });
                                                              }),
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            };
                                            // _tapGestureRecognizer.onLongTapDown = (_,a) {

                                            //     _addbookmark(
                                            //         juzNo.toString(),
                                            //         pageNo.toString(),
                                            //         surahNo.toString(),
                                            //         verseNo.toString(),position);

                                            //         };
                                            flg = false;
                                            var arabicWord = splitverse[i]
                                                    .replaceAll('.', '') +
                                                " ";
                                            rowChildren.add(TextSpan(
                                                text: arabicWord,
                                                //  +   " (" +
                                                //   ArabicNo +
                                                //  ") ",
                                                style: TextStyle(
                                                    color: ((widget.juzAyah ==
                                                                verseNo
                                                                    .toString()) &&
                                                            widget.surahno ==
                                                                surahNo
                                                                    .toString())
                                                        ? widget.color
                                                        : (arabicWord.contains(
                                                                    '۩') ==
                                                                true)
                                                            ? Colors.red
                                                            : Colors.black),
                                                recognizer:
                                                    _tapGestureRecognizer));
                                          }
                                        } else if (flg != true) {
                                          rowChildren.add(
                                            TextSpan(
                                              text: '\n\n' +
                                                  surahNames +
                                                  " Page " +
                                                  pageNo +
                                                  " Juz " +
                                                  juzNo +
                                                  " Nisf " +
                                                  Nisf.toString() +
                                                  " Ruba " +
                                                  ruba.toString() +
                                                  " Salasat " +
                                                  salasat.toString() +
                                                  '\n\n',
                                              style: TextStyle(
                                                  fontFamily: 'Schyler',
                                                  color: HexColor("#2a6e2d"),
                                                  fontSize: textFontSize,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          );
                                          rowChildren.add(
                                            TextSpan(
                                                text: verseget.replaceAll(
                                                        '.', '') +
                                                    '\n\n',
                                                style: TextStyle(
                                                  fontFamily: 'Al Qalam Quran',
                                                  color: HexColor("#2a6e2d"),
                                                  fontSize: arabictextFontSize,
                                                )), //ArabicFonts.amiri(textStyle: display1),),
                                          );
                                        } else {
                                          rowChildren.add(
                                            TextSpan(
                                                text: verseget.replaceAll(
                                                        '.', '') +
                                                    '\n\n',
                                                style: TextStyle(
                                                  fontFamily: 'Al Qalam Quran',
                                                  color: HexColor("#2a6e2d"),
                                                  fontSize: arabictextFontSize,
                                                )), //ArabicFonts.amiri(textStyle: display1),),
                                          );
                                        }
                                        if (index + 1 ==
                                            snapshot.data?.docs.length) {
                                          rowsChildrens.add(rowChildren);
                                        }

                                        final display2 = Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .copyWith(
                                              color: Colors.black,
                                              fontSize: arabictextFontSize,
                                            );
                                        return Column(
                                          crossAxisAlignment: (verseNo != 0)
                                              ? CrossAxisAlignment.end
                                              : CrossAxisAlignment.center,
                                          children: [
                                            (index == 0)
                                                ? Column(
                                                    children: [
                                                      Center(
                                                        child: Text(
                                                          surahNames +
                                                              " Page " +
                                                              pageNo +
                                                              " Juz " +
                                                              juzNo +
                                                              " Nisf " +
                                                              Nisf.toString() +
                                                              " Ruba " +
                                                              ruba.toString() +
                                                              " Salasat " +
                                                              salasat
                                                                  .toString(),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Schyler',
                                                              color: HexColor(
                                                                  "#2a6e2d"),
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      (position + 1 == val)
                                                          ? IconButton(
                                                              icon: const Icon(
                                                                  Icons.done),
                                                              onPressed: () {
                                                                addActivities(
                                                                    widget
                                                                        .juzName);
                                                                updateCounter();
                                                                const snackBar =
                                                                    SnackBar(
                                                                  content: Text(
                                                                      'Juz Completed'),
                                                                );
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        snackBar);
                                                              })
                                                          : const SizedBox(
                                                              height: 0,
                                                            )
                                                    ],
                                                  )
                                                : const SizedBox(
                                                    height: 0,
                                                  ),
                                            (index == 0)
                                                ? const Divider()
                                                : const SizedBox(height: 0),
                                            Directionality(
                                                textDirection:
                                                    TextDirection.rtl,
                                                child:
                                                    //(verseNo == 0)
                                                    // ? Column(
                                                    //     children: [
                                                    //       Text(
                                                    //         verseget,
                                                    //         textAlign:
                                                    //             TextAlign.start,
                                                    //         style: ArabicFonts.lateef(textStyle: display1),
                                                    //       ),
                                                    //       Divider()
                                                    //     ],
                                                    //   )
                                                    // :
                                                    (index + 1 ==
                                                            snapshot.data?.docs
                                                                .length)
                                                        ? Column(
                                                            children:
                                                                rowsChildrens
                                                                    .map<Widget>(
                                                                        (rowChildren) =>
                                                                            Container(
                                                                              margin: const EdgeInsets.only(top: 10),
                                                                              child: RichText(
                                                                                  textAlign: TextAlign.center,
                                                                                  text: TextSpan(
                                                                                    style: TextStyle(
                                                                                      fontFamily: 'Al Qalam Quran',
                                                                                      color: HexColor("#2a6e2d"),
                                                                                      fontSize: arabictextFontSize,
                                                                                    ), //ArabicFonts.amiri(textStyle: display1),),
                                                                                    children: rowChildren,
                                                                                  )),
                                                                            ))
                                                                    .toList(),
                                                          )
                                                        // ? Text(
                                                        //     verseget +
                                                        //         "(" +
                                                        //         verseNo.toString() +
                                                        //         ")",
                                                        //     textAlign: TextAlign.start,
                                                        //     style: new TextStyle(
                                                        //       fontFamily: ArabicFonts.Lateef,
                                                        //       package: 'google_fonts_arabic',
                                                        //       fontSize: 30.0,
                                                        //     ),
                                                        //   )
                                                        : Container(
                                                            height: 0,
                                                          )),
                                          ],
                                        );
                                      });
                                },
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Theme(
                      data: Theme.of(context)
                          .copyWith(canvasColor: Colors.transparent),
                      child: BottomNavigationBar(
                        elevation: 0,
                        currentIndex: _selectedIndex,
                        onTap: _onItemTapped,
                        selectedItemColor: HexColor("#ffde59"),
                        items: const [
                          BottomNavigationBarItem(
                              icon: Icon(Icons.home), label: 'Home'),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.list), label: 'Juz List'),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.format_list_numbered),
                              label: 'Count'),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.group), label: 'Groups'),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.bookmark), label: 'bookmarks')
                        ],
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}
