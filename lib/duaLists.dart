import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:qurankhwani/RecordPage.dart';
import 'package:qurankhwani/bookmark_page.dart';
import 'package:qurankhwani/duaPageView.dart';
import 'package:qurankhwani/group_screen.dart';
import 'package:qurankhwani/homeScreen.dart';
import 'package:qurankhwani/intro_name.dart';
import 'package:qurankhwani/main.dart';
import 'package:qurankhwani/homeScreen.dart' as list;
import 'package:qurankhwani/pageRoute.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DuaLists extends StatefulWidget {
  const DuaLists({super.key});

  @override
  State<DuaLists> createState() => _DuaListsState();
}

class _DuaListsState extends State<DuaLists> {
  var duaNames = <String>[];
  var duaNo = <String>[];
  var _selectedIndex = 5;
  @override
  void initState() {
    duaNames.addAll(list.DuaNames);
    duaNo.addAll(list.DuaNo);
    super.initState();
  }

  void filterSearchResults(String query) {
    List<String> dummyDuaNameList = <String>[];
    List<String> dummyDuaNoList = <String>[];
    query.toLowerCase();
    dummyDuaNameList.addAll(list.DuaNames);
    dummyDuaNoList.addAll(list.DuaNo);
    if (query.isNotEmpty) {
      List<String> dummyListDuaName = <String>[];
      List<String> dummyListDuaNo = <String>[];
      for (var i = 0; i < dummyDuaNameList.length; i++) {
        dummyDuaNameList[i].toLowerCase();
        if (dummyDuaNameList[i].toLowerCase().contains(query.toLowerCase())) {
          dummyListDuaName.add(dummyDuaNameList[i]);
          dummyListDuaNo.add(dummyDuaNoList[i]);
        }
      }
      setState(() {
        duaNames.clear();
        duaNo.clear();
        duaNames.addAll(dummyListDuaName);
        duaNo.addAll(dummyListDuaNo);
      });
      return;
    } else {
      setState(() {
        duaNames.clear();
        duaNo.clear();
        duaNames.addAll(list.DuaNames);
        duaNo.addAll(list.DuaNo);
      });
    }
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
          body: Container(
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
                    "Dua Lists",
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: TextStyle(color: HexColor("#ffde59")),
                cursorColor: HexColor("#ffde59"),
                onChanged: (value) {
                  filterSearchResults(value);
                },
                decoration: InputDecoration(
                  labelText: "Search",
                  labelStyle: TextStyle(color: HexColor("#ffde59")),
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  //suffixIcon: Icon(Icons.search),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusColor: HexColor("#ffde59"),
                  //suffixIconColor: HexColor("#a79162"),
                  //iconColor: HexColor("#a79162"),

                  //  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: duaNames.length,
                itemBuilder: (context, index) {
                  final display1 =
                      Theme.of(context).textTheme.headline6!.copyWith(
                            color: HexColor("#2a6e2d"),
                            fontSize: arabictextFontSize,
                          );
                  return Column(
                    children: [
                      const SizedBox(
                        height: 6,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DuasPageView(
                                    duaNames[index], duaNo[index])),
                          );
                        },
                        child: Card(
                          color: HexColor("#ffde59"),
                          child: ListTile(
                            title: Text(
                              '${duaNames[index]} ',
                              style: TextStyle(
                                color: HexColor("#2a6e2d"),
                                fontSize: textFontSize,
                                fontFamily: 'Schyler',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
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
      )),
    );
  }
}
