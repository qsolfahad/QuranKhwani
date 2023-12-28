import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:qurankhwani/RecordPage.dart';
import 'package:qurankhwani/RequestPage.dart';
import 'package:qurankhwani/add_user.dart';
import 'package:qurankhwani/bookmark_page.dart';
import 'package:qurankhwani/duaLists.dart';
import 'package:qurankhwani/grid_edit.dart';
import 'package:qurankhwani/group_screen.dart';
import 'package:qurankhwani/homeScreen.dart';
import 'package:qurankhwani/intro_name.dart';
import 'package:qurankhwani/main.dart';
import 'package:qurankhwani/pageRoute.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qurankhwani/homeScreen.dart' as list;
import 'package:qurankhwani/group_screen.dart' as grid;

class GridDetail extends StatefulWidget {
  var id;
  var myID;
  var userID;

  var grname;

  var member;

  var reason;
  GridDetail(
      this.grname, this.member, this.reason, this.id, this.myID, this.userID);

  @override
  State<GridDetail> createState() => _GridDetailState();
}

var email = '';
Map<String, String> infoColor = {};
Map<String, String> infoUser = {};

class _GridDetailState extends State<GridDetail> {
  var counts = 0;
  getEmail() async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection("Users")
        .where("userID", isEqualTo: widget.userID)
        .get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    setState(() {
      for (var i = 0; i < allData.length; i++) {
        email += allData[i]['email'] + ',';
      }
    });
  }

  var _selectedIndex = 3;
  emailSender(url) async {
    //  if (await canLaunch(url)) {
    await launch(url);
    //  } else {
    //    throw 'Could not launch $url';
    // }
  }

  getUserInfo() {
    infoColor.clear();
    infoUser.clear();
    if (grid.activities.containsKey(widget.id)) {
      //    var juzName = list.JuzNameList[index];
      String actGrp = grid.activities[widget.id].toString();
      var actSplit = actGrp.split(',');
      List juz = [];
      List user = [];
      for (var i = 0; i < actSplit.length; i++) {
        if (actSplit[i].contains('Juz')) {
          var dataSplit = actSplit[i].split(' is Completed by ');
          juz.add(dataSplit[0].replaceAll('Juz ', '').trim());
          user.add(dataSplit[1].trim());
        }
      }
      for (var j = 0; j < user.length; j++) {
        infoColor.putIfAbsent(juz[j], () => grid.userColor[user[j]].toString());
        infoUser.putIfAbsent(juz[j], () => user[j]);
      }
      print(infoUser);
    }
  }

  @override
  void initState() {
    getEmail();
    getUserInfo();
    // TODO: implement initState
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
            "Groups Detail",
            style: TextStyle(fontSize: 25, fontFamily: 'Schyler'),
          ),
          actions: [
            (widget.myID == widget.userID)
                ? IconButton(
                    color: Colors.red,
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection("Groups")
                          .doc(widget.id)
                          .delete();
                      FirebaseFirestore.instance
                          .collection("Request")
                          .where('groupID', isEqualTo: widget.id)
                          .get()
                          .then((value) => value.docs.forEach((element) {
                                FirebaseFirestore.instance
                                    .collection('Request')
                                    .doc(element.id)
                                    .delete();
                              }));
                      FirebaseFirestore.instance
                          .collection("Activities")
                          .where('groupID', isEqualTo: widget.id)
                          .get()
                          .then((value) => value.docs.forEach((element) {
                                FirebaseFirestore.instance
                                    .collection('Activities')
                                    .doc(element.id)
                                    .delete();
                              }));

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const MyHomePage(title: "Quran Khwani")));
                    },
                    icon: const Icon(Icons.delete))
                : const SizedBox(
                    height: 0,
                  ),
            (widget.myID == widget.userID)
                ? IconButton(
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GridEdit(widget.id)),
                      );
                    },
                    icon: const Icon(Icons.edit))
                : const SizedBox(),
            (widget.myID == widget.userID)
                ? IconButton(
                    color: Colors.grey,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RequestPage(widget.id)),
                      );
                    },
                    icon: const Icon(Icons.request_quote))
                : const SizedBox(),
            (widget.myID != widget.userID)
                ? IconButton(
                    color: Colors.green,
                    onPressed: () async {
                      final Uri params = Uri(
                        scheme: 'mailto',
                        path: email,
                        query:
                            'subject=Thank you for joining this Group.', //add subject and body here
                      );

                      var url = params.toString();
                      await FirebaseFirestore.instance
                          .collection('Request')
                          .where('userID', isEqualTo: widget.myID)
                          .where('groupID', isEqualTo: widget.id)
                          .get()
                          .then((value) {
                        if (value.docs.isNotEmpty) {
                          const snackBar = SnackBar(
                            content: Text('You are already Added'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          emailSender(url);
                          FirebaseFirestore.instance.collection('Request').add({
                            'userID': widget.myID,
                            'groupID': widget.id,
                            'userName': myName
                          });
                          const snackBar = SnackBar(
                            content: Text('Added to this Group'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      });
                    },
                    icon: const Icon(Icons.send_outlined))
                : IconButton(
                    color: Colors.green,
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddUser(widget.id)),
                      );
                    },
                    icon: const Icon(Icons.send_outlined)),
          ],
        ),
        body: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('Users')
                .where('userID', isEqualTo: widget.userID)
                .get(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              DocumentSnapshot ds = snapshot.data!.docs[0];
              var image = File(ds['image']);
              var name = ds['userName'];

              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Created by",
                      style: TextStyle(
                          fontSize: 25,
                          color: HexColor("#30652c"),
                          fontFamily: 'Schyler'),
                    ),
                    const Divider(),
                    Center(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: const Color(0xffFDCF09),
                        child:
                            //  image != null
                            //     ? ClipRRect(
                            //         borderRadius: BorderRadius.circular(50),
                            //         child: Image.file(
                            //           image,
                            //           width: 100,
                            //           height: 100,
                            //           fit: BoxFit.cover,
                            //         ),
                            //       )
                            //     :
                            Center(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(50)),
                            width: 100,
                            height: 100,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      name,
                      style: TextStyle(
                          fontSize: 20,
                          color: HexColor("#30652c"),
                          fontFamily: 'Schyler'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            width: MediaQuery.of(context).size.shortestSide / 2,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: HexColor("#2a6e2d"),
                                width: 5, // red as border color
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                "Group Name: " + widget.grname,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: HexColor("#30652c"),
                                    fontFamily: 'Schyler'),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Flexible(
                            child: Container(
                          width: MediaQuery.of(context).size.shortestSide / 2,
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: HexColor("#2a6e2d"),
                              width: 5, // red as border color
                            ),
                          ),
                          child: Text(
                            'Total Member: ' + widget.member.toString(),
                            style: TextStyle(
                                fontSize: 20,
                                color: HexColor("#30652c"),
                                fontFamily: 'Schyler'),
                          ),
                        ))
                      ],
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Reason',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 25,
                          color: HexColor("#30652c"),
                          fontFamily: 'Schyler'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        widget.reason,
                        style: TextStyle(
                            fontSize: 20,
                            color: HexColor("#30652c"),
                            fontFamily: 'Schyler'),
                      ),
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),

                    // Text(
                    //   'Activities',
                    //   textAlign: TextAlign.left,
                    //   style: TextStyle(
                    //       fontSize: 25,
                    //       color: HexColor("#30652c"),
                    //       fontFamily: 'Schyler'),
                    // ),
                    // FutureBuilder(
                    //     future: FirebaseFirestore.instance
                    //         .collection('Activities')
                    //         .where('groupID', isEqualTo: widget.id)
                    //         .get(),
                    //     builder: (BuildContext context,
                    //         AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                    //             snapshot) {
                    //       if (!snapshot.hasData) {
                    //         return const Center(
                    //           child: CircularProgressIndicator(),
                    //         );
                    //       }
                    //       return ListView.builder(
                    //           shrinkWrap: true,
                    //           physics: const NeverScrollableScrollPhysics(),
                    //           itemCount: snapshot.data!.docs.length,
                    //           itemBuilder: (context, index) {
                    //             DocumentSnapshot ds = snapshot.data!.docs[index];
                    //             var des = ds['description'];
                    //             return Card(
                    //               child: ListTile(
                    //                 title: Text(des,
                    //                     style: TextStyle(
                    //                         fontSize: 20,
                    //                         color: HexColor("#30652c"),
                    //                         fontFamily: 'Schyler')),
                    //               ),
                    //             );
                    //           });
                    //     }),
                    Text(
                      'Juz Activities',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 25,
                          color: HexColor("#30652c"),
                          fontFamily: 'Schyler'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: SizedBox(
                          width: 500,
                          height: 500,
                          child: GridView.count(
                            crossAxisCount: 5,
                            children: List.generate(30, (index) {
                              counts = index + 1;
                              var juzCheck = list.JuzNameList[index];

                              return Card(
                                  elevation: 3,
                                  child: GestureDetector(
                                    onTap: () {
                                      FlutterTts tts = FlutterTts();
                                      //  tts.setLanguage("ar-SA");
                                      if (infoUser[juzCheck] != null) {
                                        tts.speak(
                                            infoUser[juzCheck].toString());
                                      }
                                    },
                                    child: Container(
                                      //width: MediaQuery.of(context).size.width/8.6,
                                      width: MediaQuery.of(context).size.width /
                                          3.9,
                                      decoration: BoxDecoration(
                                        color: (infoColor.containsKey(juzCheck))
                                            ? HexColor(
                                                infoColor[juzCheck].toString())
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(60),
                                      ),
                                      child: Column(
                                        children: [
                                          Center(
                                              child: Text(
                                            counts.toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ));
                            }),
                          ),
                        ))),

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
                                    icon:
                                        const Icon(Icons.format_list_numbered),
                                    label: 'Count',
                                    backgroundColor: HexColor('#2a6e2d')),
                                BottomNavigationBarItem(
                                    icon: const Icon(Icons.group),
                                    label: 'Groups',
                                    backgroundColor: HexColor('#2a6e2d')),
                                BottomNavigationBarItem(
                                    icon: const Icon(Icons.bookmark),
                                    label: 'bookmarks',
                                    backgroundColor: HexColor('#2a6e2d')),
                                const BottomNavigationBarItem(
                                    icon: Icon(Icons.panorama_fisheye_rounded),
                                    label: 'Duas')
                              ],
                            ))),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
