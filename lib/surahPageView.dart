import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:qurankhwani/RecordSurahPage.dart';
import 'package:qurankhwani/SurahLists.dart';
import 'package:qurankhwani/bookmark_page.dart';
import 'package:qurankhwani/duaLists.dart';
import 'package:qurankhwani/group_screen.dart';
import 'package:qurankhwani/homeScreen.dart';
import 'package:qurankhwani/intro_name.dart';
import 'package:qurankhwani/main.dart';
//import 'package:google_fonts_arabic/fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qurankhwani/homeScreen.dart' as list;

class SurahPageView extends StatefulWidget {
  var surahName;
  var surahAyah;
  var surahNo;
  var surahPage;
  var surahEndPage;
  Color color;
  int currVal;

  var verseno;

  SurahPageView(this.surahName, this.verseno, this.surahNo, this.surahAyah,
      this.surahPage, this.surahEndPage, this.currVal, this.color);
  @override
  State<SurahPageView> createState() => _SurahPageViewState();
}

class _SurahPageViewState extends State<SurahPageView> {
  var sub;
  var val;
  final _formKey = GlobalKey<FormState>();
  late LongPressGestureRecognizer _tapGestureRecognizer;

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

  var _selectedIndex = 1;
  Future<void> _onItemTapped(int index) async {
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
        MaterialPageRoute(builder: (context) => const SurahList()),
      );
    }
    if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RecordSurahPage()),
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GroupScreen(false)),
        );
      }
    }
    if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BookmarkPage()),
      );
    }
    if (index == 5) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DuaLists()),
      );
    }
  }

  Future<void> _addbookmark(String surahname, int verseno, int pageno,
      int juzno, int surahno, int pos) async {
    try {
      var flag = true;
      var value = await FirebaseAuth.instance.signInAnonymously();
      var bookmarkdb = FirebaseFirestore.instance.collection("Bookmarks");
      sub = bookmarkdb
          .where("userId", isEqualTo: value.user!.uid)
          .where("surahNo", isEqualTo: surahno)
          .where("verseNo", isEqualTo: verseno)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          print("working");
          _showMessageInScaffold("Already added bookmark");
          flag = false;
          print("The state: " + flag.toString());
        } else {
          print("Added");
          bookmarkdb.add({
            "userId": value.user!.uid,
            "createdDate": DateTime.now(),
            "surahName": surahname,
            'state': 'Surah',
            "surahNo": surahno,
            "verseNo": verseno,
            'startVerseNo': widget.surahPage,
            'surahAyah': widget.surahAyah,
            'endVerseNo': widget.surahEndPage,
            'position': pos,
            "pageNo": pageno,
            "juzNo": juzno,
          });
          _showMessageInScaffold("Added bookmark");
          sub.cancel();
        }
      });
    } catch (e) {
      print(e); // TODO: show dialog with error
    }
  }

  void updateCounter() async {
    var uservalue = await FirebaseAuth.instance.signInAnonymously();
    await FirebaseFirestore.instance
        .collection("UserRecord")
        .where("UserId", isEqualTo: uservalue.user?.uid)
        .where("name", isEqualTo: 'surah')
        .get()
        .then((value) => value.docs.forEach((element) {
              FirebaseFirestore.instance
                  .collection("UserRecord")
                  .doc(element.id)
                  .update({
                "${widget.surahName}": element.data()[widget.surahName] + 1
              });
              list.surahCount[widget.surahName] =
                  element.data()[widget.surahName] + 1;
            }));
  }

  addActivities(surahname, myName) async {
    var value = await FirebaseAuth.instance.signInAnonymously();
    FirebaseFirestore.instance
        .collection("Request")
        .where('userID', isEqualTo: value.user?.uid)
        .get()
        .then((value) => value.docs.forEach((element) {
              print(element.data()['userName']);
              if (element.data()['userName'] == '') {
                FirebaseFirestore.instance.collection("Activities").add({
                  'groupID': element.data()['groupID'],
                  'description':
                      'Surah ' + surahname + ' is Completed by ' + 'anonymous',
                  'createdDate': DateTime.now(),
                });
              } else {
                FirebaseFirestore.instance.collection("Activities").add({
                  'groupID': element.data()['groupID'],
                  'description': 'Surah ' +
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
      "surahName": widget.surahName,
      "surahNo": widget.surahNo,
      "surahAyah": widget.surahAyah,
      "surahPage": widget.surahPage,
      "surahEndPage": widget.surahEndPage,
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
    val = int.parse(widget.surahEndPage) - int.parse(widget.surahPage) + 1;
    print(val.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                widget.surahName +
                    " " +
                    widget.surahNo +
                    ":" +
                    widget.surahAyah,
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
                                  .where("surahNo", isEqualTo: widget.surahNo)
                                  .where("pageNo",
                                      isEqualTo: (int.parse(widget.surahPage) +
                                              position)
                                          .toString())
                                  .orderBy("verseNo")
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
                                      List<List<TextSpan>> rowsChildrens = [];
                                      //print(snapshot.data?.docs.length);

                                      if (verseNo != 0) {
                                        var splitverse = verseget.split(' ');
                                        for (var i = 0;
                                            i < splitverse.length;
                                            i++) {
                                          _tapGestureRecognizer =
                                              LongPressGestureRecognizer();
                                          _tapGestureRecognizer.onLongPress =
                                              () {
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
                                                                widget
                                                                    .surahName,
                                                                verseNo,
                                                                int.parse(
                                                                    pageNo),
                                                                int.parse(
                                                                    juzNo),
                                                                int.parse(widget
                                                                    .surahNo),
                                                                position,
                                                              );
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
                                                                      title: Text(splitverse[i].replaceAll(
                                                                              '.',
                                                                              '') +
                                                                          " "),
                                                                    );
                                                                  });
                                                            }),
                                                      ],
                                                    ),
                                                  );
                                                });
                                          };

                                          var arabicWord = splitverse[i]
                                                  .replaceAll('.', '') +
                                              " ";
                                          rowChildren.add(TextSpan(
                                              text: splitverse[i]
                                                      .replaceAll('.', '') +
                                                  " ",
                                              // " (" +
                                              // ArabicNo +
                                              // ") ",
                                              style: TextStyle(
                                                  color: (widget.verseno ==
                                                          verseNo.toString())
                                                      ? Colors.green
                                                      : (arabicWord.contains(
                                                                  '۩') ==
                                                              true)
                                                          ? Colors.red
                                                          : Colors.black),
                                              recognizer:
                                                  _tapGestureRecognizer));
                                        }
                                      }
                                      if (index + 1 ==
                                          snapshot.data?.docs.length) {
                                        rowsChildrens.add(rowChildren);
                                      }
                                      final display1 = Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                            color: HexColor("#2a6e2d"),
                                            fontSize: arabictextFontSize,
                                          );
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
                                                        widget.surahName +
                                                            " Page " +
                                                            pageNo +
                                                            " Juz " +
                                                            juzNo +
                                                            " Nisf " +
                                                            Nisf.toString() +
                                                            " Ruba " +
                                                            ruba.toString() +
                                                            " Salasat " +
                                                            salasat.toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Schyler',
                                                            color: HexColor(
                                                                "#2a6e2d"),
                                                            fontSize:
                                                                textFontSize,
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
                                                                      .surahName,
                                                                  myName);
                                                              updateCounter();
                                                              const snackBar =
                                                                  SnackBar(
                                                                content: Text(
                                                                    'Surah Completed'),
                                                              );
                                                              ScaffoldMessenger
                                                                      .of(
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
                                              textDirection: TextDirection.rtl,
                                              child: (verseNo == 0)
                                                  ? Column(
                                                      children: [
                                                        Text(
                                                          verseget,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Al Qalam Quran',
                                                            color: HexColor(
                                                                "#2a6e2d"),
                                                            fontSize:
                                                                arabictextFontSize,
                                                          ), //ArabicFonts.amiri(textStyle: display1),
                                                        ),
                                                        const Divider()
                                                      ],
                                                    )
                                                  : (index + 1 ==
                                                          snapshot.data?.docs
                                                              .length)
                                                      ? Column(
                                                          children:
                                                              rowsChildrens
                                                                  .map<Widget>(
                                                                      (rowChildren) =>
                                                                          Container(
                                                                            margin:
                                                                                const EdgeInsets.only(top: 10),
                                                                            child: RichText(
                                                                                textAlign: TextAlign.center,
                                                                                text: TextSpan(
                                                                                  style: TextStyle(
                                                                                    fontFamily: 'Al Qalam Quran',
                                                                                    color: Colors.black,
                                                                                    fontSize: arabictextFontSize,
                                                                                  ), //ArabicFonts.amiri(textStyle: display2),
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
                            icon: Icon(Icons.list), label: 'Surah List'),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.format_list_numbered),
                            label: 'Count'),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.group), label: 'Groups'),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.bookmark), label: 'bookmarks'),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.panorama_fisheye_rounded),
                            label: 'Duas')
                      ],
                    ))),
          ],
        ),
      ),
    );
  }
}
