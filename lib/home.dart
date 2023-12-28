//import 'package:animated_drawer/views/animated_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qurankhwani/homeScreen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MyHomePage(
      title: 'Quran Khwani',
    );
    // return AnimatedDrawer(
    //   homePageXValue: 150,
    //   homePageYValue: 80,
    //   homePageAngle: -0.2,
    //   homePageSpeed: 250,
    //   shadowXValue: 122,
    //   shadowYValue: 110,
    //   shadowAngle: -0.275,
    //   shadowSpeed: 450,
    //   openIcon: Icon(Icons.menu_open, color: HexColor("#ffde59")),
    //   closeIcon: Icon(Icons.arrow_back_ios, color: HexColor("#ffde59")),
    //   shadowColor: Colors.white24,
    //   backgroundGradient: LinearGradient(
    //     colors: [Colors.black, Colors.black],
    //   ),
    //   menuPageContent: MyDrawer(),
    //   homePageContent: MyHomePage(
    //     title: 'Quran Khwani',
    //   ),
    // );
  }
}
