import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:qurankhwani/bookmark_page.dart';
import 'package:qurankhwani/group_screen.dart';
import 'package:qurankhwani/intro_name.dart';
import 'package:qurankhwani/juzLists.dart';
import 'package:qurankhwani/main.dart' as main;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[400]!, Colors.green[700]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: const Color(0xffFDCF09),
                child: main.url != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.file(
                          main.url,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
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
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    "QURAN",
                    style: TextStyle(
                        fontSize: 17,
                        color: HexColor("#ffde59"),
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Khwani",
                    style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'Schyler',
                        color: Colors.blue[200],
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const JuzList();
                  }));
                },
                leading: const Icon(
                  Icons.list,
                  color: Colors.white,
                ),
                title: const Text(
                  'Surah List',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const BookmarkPage();
                  }));
                },
                leading: const Icon(
                  Icons.list,
                  color: Colors.white,
                ),
                title: const Text(
                  'Bookmarks',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ListTile(
                onTap: () async {
                  var uservalue =
                      await FirebaseAuth.instance.signInAnonymously();
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
                      MaterialPageRoute(
                          builder: (context) => GroupScreen(false)),
                    );
                  }
                },
                leading: const Icon(
                  Icons.list,
                  color: Colors.white,
                ),
                title: const Text(
                  'Groups',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              const Text(
                "About",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
