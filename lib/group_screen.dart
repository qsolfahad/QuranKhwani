// ignore_for_file: avoid_unnecessary_containers
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:qurankhwani/RecordPage.dart';
import 'package:qurankhwani/add_groups.dart';
import 'package:qurankhwani/bookmark_page.dart';
import 'package:qurankhwani/duaLists.dart';
import 'package:qurankhwani/grid_detail.dart';
import 'package:qurankhwani/homeScreen.dart';
import 'package:qurankhwani/intro_name.dart';
import 'package:qurankhwani/pageRoute.dart';

class GroupScreen extends StatefulWidget {
  var isfavourite;
  GroupScreen(this.isfavourite);

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

Map<String, String> activities = {};
Map<String, String> userColor = {};

class _GroupScreenState extends State<GroupScreen> {
  var myID;
  var _selectedIndex = 3;
  getUserId() async {
    var uservalue = await FirebaseAuth.instance.signInAnonymously();
    myID = uservalue.user?.uid.toString();
  }

  getGridViewInfo() async {
    activities.clear();
    var makelist = '';
    await FirebaseFirestore.instance
        .collection('Activities')
        .orderBy('groupID')
        .orderBy('createdDate', descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        if (activities.containsKey(element.data()['groupID'])) {
          //  if(element.data()['description'].contains('Juz'))
          makelist += ',' + element.data()['description'];
          activities.update(element.data()['groupID'], (value) => makelist);
        } else {
          makelist = '';
          // if(element.data()['description'].contains('Juz'))
          makelist = element.data()['description'];
          activities.putIfAbsent(element.data()['groupID'], () => makelist);
        }
      }
    });
    // print(activities['vIMlQNVDThKr2P665R5Q']);
  }

  getUserColor() async {
    await FirebaseFirestore.instance.collection('Users').get().then((value) {
      for (var element in value.docs) {
        userColor.putIfAbsent(
            element.data()['userName'], () => element.data()['hexColor']);
      }
    });
    print(userColor);
  }

  // intro() {
  //   Navigator.pushReplacement(
  //       context, MaterialPageRoute(builder: (context) => IntroName()));
  // }

  // route() {
  //   Navigator.pushReplacement(
  //       context, MaterialPageRoute(builder: (context) => GroupScreen(false)));
  // }

  // startTime() async {
  //   var duration = new Duration(seconds: 1);
  //   // SharedPreferences prefs = await SharedPreferences.getInstance();
  //   // var check = prefs.getBool("intro");
  //   var uservalue = await FirebaseAuth.instance.signInAnonymously();
  //   var check = 0;
  //   var data = await FirebaseFirestore.instance
  //       .collection("Users")
  //       .where("userID", isEqualTo: uservalue.user?.uid)
  //       .get()
  //       .then((value) => check = value.size);
  //   if (check == 0) {
  //     return new Timer(duration, intro);
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    // startTime();
    getUserId();
    getGridViewInfo();
    getUserColor();
    super.initState();
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
    getAllData() {
      return FirebaseFirestore.instance.collection("Groups").get();
    }

    getUserData() async {
      var uservalue = await FirebaseAuth.instance.signInAnonymously();
      return FirebaseFirestore.instance
          .collection("Groups")
          .where('userID', isEqualTo: uservalue.user?.uid)
          .get();
    }

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
              "Groups",
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'Schyler',
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const addGroups()),
                    );
                  },
                  icon: const Icon(Icons.add)),
              IconButton(
                  color:
                      (widget.isfavourite == false) ? Colors.grey : Colors.red,
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                (widget.isfavourite == false)
                                    ? GroupScreen(true)
                                    : GroupScreen(false)));
                  },
                  icon: const Icon(Icons.favorite))
            ],
          ),
          body: Container(
            child: Column(
              children: [
                Expanded(
                  child: FutureBuilder(
                    future: (widget.isfavourite == false)
                        ? getAllData()
                        : getUserData(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return GridView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = snapshot.data!.docs[index];
                          var grname = ds['groupName'];
                          var member = ds['groupMember'];
                          var reason = ds['reason'];
                          var userID = ds['userID'];
                          var id = ds.id;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(
                                          5.0) //                 <--- border radius here
                                      ),
                                  border:
                                      Border.all(color: HexColor("#30652c"))),
                              child: GridTile(
                                //color: HexColor("#30652c"),
                                //elevation: 10,

                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Center(
                                        child: Text(grname,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: 'Schyler',
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: HexColor("#30652c"))),
                                      ),
                                    ),
                                    const Divider(),
                                  ],
                                ),
                                footer: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.green[400]!,
                                        Colors.green[700]!
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: GridTileBar(
                                    subtitle: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(reason.toString(),
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: HexColor("#ffde59"))),
                                    ),
                                    trailing: IconButton(
                                      color: HexColor("#ffde59"),
                                      icon: const Icon(Icons.arrow_right_sharp),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => GridDetail(
                                                  grname,
                                                  member,
                                                  reason,
                                                  id,
                                                  myID,
                                                  userID)),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 15,
                        ),
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
                                label: 'Duas')
                          ],
                        ))),
              ],
            ),
          )),
    );
  }
}
