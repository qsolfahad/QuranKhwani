import 'dart:async';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';
import 'package:qurankhwani/home.dart';

class InitState extends StatefulWidget {
  const InitState({Key? key}) : super(key: key);

  @override
  State<InitState> createState() => _InitStateState();
}

class _InitStateState extends State<InitState> {
  startTime() async {
    var duration = const Duration(seconds: 4);
    return Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: HexColor('F5F9FC'),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Image.asset("assets/image/Qurankhwani.png"),
              ),
              const Padding(padding: EdgeInsets.only(top: 20.0)),
              //Text(
              // "Splash Screen",
              // style: TextStyle(
              //   fontSize: 20.0,
              // ),
              //),
              const Padding(padding: EdgeInsets.only(top: 20.0)),
            ],
          ),
        ),
      ),
    );
  }
}
