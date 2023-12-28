import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qurankhwani/RecordPage.dart';
import 'package:qurankhwani/duaLists.dart';
import 'package:qurankhwani/group_screen.dart';
import 'package:qurankhwani/homeScreen.dart';
import 'package:qurankhwani/intro_name.dart';
import 'package:qurankhwani/juzPageView.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:qurankhwani/main.dart';
import 'package:qurankhwani/pageRoute.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  var _selectedIndex = 4;
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
    if (index == 5) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DuaLists()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green[400]!, Colors.green[700]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            title: const Text(
              "Bookmarks",
              style: TextStyle(fontSize: 25, fontFamily: 'Schyler'),
            ),
            leading: IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyHomePage(
                              title: 'Quran Khwani',
                            )),
                    (Route<dynamic> route) => false,
                  );
                },
                icon: const Icon(Icons.arrow_back_sharp))),
        body: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('Bookmarks')
                .where('state', isEqualTo: 'Juz')
                .orderBy("createdDate", descending: true)
                .get(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = snapshot.data!.docs[index];
                          String title =
                              (ds["juzName"] != null) ? ds["juzName"] : '';
                          var juzno = (ds["juzNo"] != null) ? ds["juzNo"] : '';
                          var pageno =
                              (ds["pageNo"] != null) ? ds["pageNo"] : '';
                          var verseno =
                              (ds["verseno"] != null) ? ds["verseno"] : '';
                          var endVerseNo = (ds['endVerseNo'] != null)
                              ? ds['endVerseNo']
                              : '';
                          var startVerseNo = (ds['startVerseNo'] != null)
                              ? ds['startVerseNo']
                              : '';
                          var surahno =
                              (ds['surahNo'] != null) ? ds['surahNo'] : '';
                          var position =
                              (ds['position'] != null) ? ds['position'] : 0;
                          var value = index + 1;
                          return Column(
                            children: [
                              GestureDetector(
                                child: (title != '')
                                    ? Center(
                                        child: Card(
                                            margin: const EdgeInsets.all(8),

                                            //  height: 50,
                                            // width: 100,
                                            color: HexColor("#ffde59"),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                child: Center(
                                                    child: Text(
                                                        title +
                                                            " " +
                                                            juzno.toString() +
                                                            ":" +
                                                            surahno.toString() +
                                                            ':' +
                                                            verseno.toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: HexColor(
                                                              "#2a6e2d"),
                                                          fontFamily: 'Schyler',
                                                          fontSize:
                                                              textFontSize,
                                                        ))))))
                                    : const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                onLongPress: () {
                                  print('in');
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          scrollable: true,
                                          title: const Text(
                                              'Are you sure to delete this Bookmark?'),
                                          actions: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                  onPressed: () async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('Bookmarks')
                                                        .doc(ds.id)
                                                        .delete();
                                                    Navigator
                                                        .pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const BookmarkPage()),
                                                      (Route<dynamic> route) =>
                                                          false,
                                                    );
                                                  },
                                                  child: const Text('Yes'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('No'),
                                                ),
                                              ],
                                            )
                                          ],
                                        );
                                      });
                                },
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => JuzPageView(
                                              title,
                                              juzno.toString(),
                                              verseno.toString(),
                                              startVerseNo.toString(),
                                              endVerseNo.toString(),
                                              surahno.toString(),
                                              position,
                                              Colors.green)));
                                },
                              ),
                            ],
                          );
                        }),
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
                            items: [
                              BottomNavigationBarItem(
                                  icon: const Icon(Icons.home),
                                  label: 'Home',
                                  backgroundColor: HexColor('#2a6e2d')),
                              BottomNavigationBarItem(
                                  icon: const Icon(Icons.list),
                                  label: 'Juz List',
                                  backgroundColor: HexColor('#2a6e2d')),
                              BottomNavigationBarItem(
                                  icon: const Icon(Icons.format_list_numbered),
                                  label: 'Count',
                                  backgroundColor: HexColor('#2a6e2d')),
                              BottomNavigationBarItem(
                                  icon: const Icon(Icons.group),
                                  label: 'Groups',
                                  backgroundColor: HexColor('#2a6e2d')),
                              BottomNavigationBarItem(
                                  icon: const Icon(Icons.bookmark),
                                  label: 'Bookmarks',
                                  backgroundColor: HexColor('#2a6e2d')),
                              const BottomNavigationBarItem(
                                  icon: Icon(Icons.panorama_fisheye_rounded),
                                  label: 'Duas'),
                            ],
                          ))),
                ],
              );
            }),
      ),
    );
  }
}
