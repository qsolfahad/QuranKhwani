import 'dart:async';
import 'dart:io';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:qurankhwani/InitState.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adhan_dart/adhan_dart.dart';
import 'package:geolocator/geolocator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

var url = File("");
var myName = '';
var myID;
double textFontSize = 20;
double arabictextFontSize = 30;
var dropdownvalue = "NorthAmerica";
var coordinates;
var location;
String time = '';
int order = 0;
getMethod() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  dropdownvalue = (prefs.getString('saveMethod'))!;
}

getFontSize() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  textFontSize = (prefs.getDouble('saveTextFont'))!;
  textFontSize ??= 20;
}

getArabicFontSize() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  arabictextFontSize = (prefs.getDouble('saveArabictextFont'))!;
  arabictextFontSize ??= 30;
}

getUserId() async {
  var uservalue = await FirebaseAuth.instance.signInAnonymously();
  myID = uservalue.user?.uid.toString();
}

Future<Position> getLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  print(serviceEnabled);
  if (!serviceEnabled) {
    throw 'Location services are disabled.';
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    throw 'Location permissions are permanently denied.';
  }

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      throw 'Location permissions are denied.';
    }
  }

  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}

getCoordinates() async {
  final position = await getLocation();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  coordinates = Coordinates(position.latitude, position.longitude);
  if (coordinates != null) {
    print('setting cordinates');
    prefs.setDouble('saveLatitude', position.latitude);
    prefs.setDouble('saveLongitude', position.longitude);
  } // Replace with your desired coordinates
  String dtz = await FlutterNativeTimezone.getLocalTimezone();
  // Create a PrayerTimes instance for the desired date and coordinates

  tz.initializeTimeZones();

  location = tz.getLocation(dtz);
  if (location != null) {
    print('setting location');
    prefs.setString('saveLocation', dtz);
  }
}

getLocationFromCache() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (location == null) {
    tz.initializeTimeZones();
    String dtz = (prefs.getString('saveLocation'))!;
    print('getting location');

    double lat = (prefs.getDouble('saveLatitude'))!;
    double lon = (prefs.getDouble('saveLongitude'))!;

    location = tz.getLocation(dtz);
    coordinates = Coordinates(lat, lon);
    print(location);
    print(coordinates);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quran Khwani',
      theme: ThemeData(
        colorScheme: ThemeData().colorScheme.copyWith(
              secondary: Colors.red,
            ),
        primaryColor: HexColor("#ffde59"),
        scaffoldBackgroundColor: HexColor("#ffffff"),
        textTheme: TextTheme(
            headline1: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            headline2: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: HexColor("#ffde59")),
            headline4: TextStyle(
              color: HexColor("#ffde59"),
            )),
      ).copyWith(
        colorScheme: ThemeData().colorScheme.copyWith(
              onSecondary: HexColor("#ffde59"),
              onPrimary: HexColor("#ffde59"),

              // background: HexColor("#d8ec9c"),
              //  onBackground: HexColor("#d8ec9c"),
            ),
      ),
      home: const InitState(),
    );
  }
}
