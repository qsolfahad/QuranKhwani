//import 'package:animated_drawer/views/home_page.dart';
import 'package:flutter/material.dart';
//import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:qurankhwani/RecordPage.dart';
import 'package:qurankhwani/bookmark_page.dart';
import 'package:qurankhwani/duaLists.dart';
import 'package:qurankhwani/group_screen.dart';
import 'package:qurankhwani/homeScreen.dart' as list;
import 'package:qurankhwani/homeScreen.dart';
import 'package:qurankhwani/intro_name.dart';
import 'package:qurankhwani/juzPageView.dart';
import 'package:qurankhwani/main.dart';
import 'package:qurankhwani/pageRoute.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qurankhwani/main.dart' as data;

class JuzList extends StatefulWidget {
  const JuzList();

  @override
  State<JuzList> createState() => _JuzListState();
}

class _JuzListState extends State<JuzList> {
  TextEditingController editingController = TextEditingController();

  _buildLastBookmarkView(Color color) {
    //String data = title[1]["surahName"];
    return Center(
      child: Container(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Bookmarks')
                .where("userId", isEqualTo: data.myID)
                .where('state', isEqualTo: 'Juz')
                .orderBy("createdDate", descending: true)
                .limit(3)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data!.docs.isEmpty) {
                return const SizedBox(
                  height: 0,
                );
              } else {
                return Column(
                  children: [
                    SizedBox(
                      height: 68,
                      child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            //  if (index == 0) {
                            //  return _buildLastView(HexColor("#68A629"));
                            // }
                            //index--;
                            DocumentSnapshot ds = snapshot.data!.docs[index];

                            String title = ds["juzName"];
                            var juzno = ds["juzNo"];
                            var pageno = ds["pageNo"];
                            var verseno = ds["verseno"];
                            var endVerseNo = ds['endVerseNo'];
                            var startVerseNo = ds['startVerseNo'];
                            var position = ds['position'];
                            var value = index + 1;
                            return GestureDetector(
                              child: (title != '')
                                  ? Center(
                                      child: Card(
                                          margin: const EdgeInsets.all(8),

                                          //  height: 50,
                                          // width: 100,
                                          color: HexColor("#ffde59"),
                                          child: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: Center(
                                                  child: Text(
                                                      title +
                                                          " " +
                                                          juzno.toString() +
                                                          ":" +
                                                          pageno.toString() +
                                                          ':' +
                                                          verseno.toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color:
                                                            HexColor("#2a6e2d"),
                                                        fontFamily: 'Schyler',
                                                      ))))))
                                  : const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                              onTap: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => JuzPageView(
                                            title,
                                            juzno.toString(),
                                            verseno.toString(),
                                            startVerseNo.toString(),
                                            endVerseNo.toString(),
                                            '',
                                            position,
                                            Colors.green)));
                              },
                            );
                          }),
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }

  //   List<String>.generate(114, (i) => quran.getSurahName(i + 1));
  var items = <String>[];
  var itemsAr = <String>[];
  var JuzNo = <String>[];
  var JuzPage = <String>[];
  var JuzEndPages = <String>[];
  var _selectedIndex = 1;
  @override
  void initState() {
    items.addAll(list.JuzNameList);
    itemsAr.addAll(list.JuzArabicNameList);
    JuzNo.addAll(list.JuzNo);
    JuzPage.addAll(list.JuzPages);
    JuzEndPages.addAll(list.JuzEndPages);
    super.initState();
  }

  void filterSearchResults(String query) {
    List<String> dummySearchList = <String>[];
    List<String> dummySearchListAr = <String>[];
    List<String> dummySearchJuzNo = <String>[];
    List<String> dummySearchJuzPage = <String>[];
    List<String> dummySearchJuzEndPages = <String>[];
    query.toLowerCase();
    dummySearchList.addAll(list.JuzNameList);
    dummySearchListAr.addAll(list.JuzArabicNameList);
    dummySearchJuzNo.addAll(list.JuzNo);
    dummySearchJuzPage.addAll(list.JuzPages);
    dummySearchJuzEndPages.addAll(list.JuzEndPages);

    if (query.isNotEmpty) {
      List<String> dummyListData = <String>[];
      List<String> dummyListDataAr = <String>[];
      List<String> dummyListJuzNo = <String>[];
      List<String> dummyListJuzPage = <String>[];
      List<String> dummyListJuzEndPages = <String>[];
      for (var i = 0; i < dummySearchList.length; i++) {
        dummySearchList[i].toLowerCase();
        if (dummySearchList[i].toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(dummySearchList[i]);
          dummyListDataAr.add(dummySearchListAr[i]);
          dummyListJuzNo.add(dummySearchJuzNo[i]);
          dummyListJuzPage.add(dummySearchJuzPage[i]);
          dummyListJuzEndPages.add(dummySearchJuzEndPages[i]);
        }
      }
      setState(() {
        items.clear();
        itemsAr.clear();
        JuzNo.clear();

        JuzPage.clear();
        JuzEndPages.clear();
        items.addAll(dummyListData);
        itemsAr.addAll(dummyListDataAr);
        JuzNo.addAll(dummyListJuzNo);
        JuzPage.addAll(dummyListJuzPage);
        JuzEndPages.addAll(dummyListJuzEndPages);
      });
      return;
    } else {
      setState(() {
        items.clear();
        itemsAr.clear();
        JuzNo.clear();

        JuzPage.clear();
        JuzEndPages.clear();
        items.addAll(list.JuzNameList);
        itemsAr.addAll(list.JuzArabicNameList);
        JuzNo.addAll(list.JuzNo);
        JuzPage.addAll(list.JuzPages);
        JuzEndPages.addAll(list.JuzEndPages);
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
    var textscale = MediaQuery.of(context).textScaleFactor;
    return SafeArea(
      child: Scaffold(
          backgroundColor: HexColor('F5F9FC'),
           
          body: Container(
        
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                IconButton(
                  icon: ImageIcon(AssetImage('assets/image/back.png')),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Spacer(),
                Text(
                  "Juz List",
                  style:  GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                fontSize: 40,
                                color: HexColor('#2a6e2d'),
                                fontWeight: FontWeight.bold)),
                ),
                 Spacer(),
                IconButton(
                  icon: ImageIcon(AssetImage('assets/image/search.png')),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: TextStyle(color: Colors.lightGreen),
                cursorColor: Colors.lightGreen,
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                  labelText: "Search",
                  labelStyle: TextStyle(color: Colors.lightGreen),
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
                  focusColor:  Colors.lightGreen,
                  //suffixIconColor: HexColor("#a79162"),
                  //iconColor: HexColor("#a79162"),

                  //  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            _buildLastBookmarkView(HexColor("#68A629")),
            SizedBox(height: 20,),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2, // You can adjust the number of columns as needed
    crossAxisSpacing: 8.0, // Adjust the spacing between columns
    mainAxisSpacing: 8.0, // Adjust the spacing between rows
  ),
                itemCount: items.length,
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
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => JuzPageView(
                                    items[index],
                                    JuzNo[index].toString(),
                                    '',
                                    JuzPage[index].toString(),
                                    JuzEndPages[index].toString(),
                                    '',
                                    0,
                                    Colors.black)),
                          );
                        },
                        child: Container(
                          height: 167,
                          width: 171,
                          decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(25), color: Colors.white),
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${items[index]} ',
                                 style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                   fontSize: textFontSize,
                                  color: HexColor('#2a6e2d'),
                                  fontWeight: FontWeight.bold))
                              ),
                            ),
                            subtitle: Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                '${itemsAr[index]} ',
                                style: GoogleFonts.lateef(textStyle: display1),
                                // style: TextStyle(
                                //   color: HexColor("#2a6e2d"),
                                //   fontFamily: ArabicFonts.Lateef,
                                //   package: 'google_fonts_arabic',
                                //   fontSize: 30,
                                // ),
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
                      selectedItemColor:  Colors.lightGreen,
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
