import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:adhan_dart/adhan_dart.dart';
import 'package:qurankhwani/notify.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qurankhwani/main.dart' as data;
import 'package:permission_handler/permission_handler.dart';

class PrayerTime extends StatefulWidget {
  const PrayerTime({super.key});

  @override
  State<PrayerTime> createState() => _PrayerTimeState();
}

var items = [
  'Dubai',
  'Egyptian',
  'Karachi',
  'Kuwait',
  'MoonsightingCommittee',
  'Morocco',
  'MuslimiorldLeague',
  'NorthAmerica',
  'Qatar',
  'Singapore',
  'Tehran',
  'Turkey',
  'UmmAlQura',
  'Other'
];

class _PrayerTimeState extends State<PrayerTime> {
  @override
  final prayerNames = [
    'Fajr',
    'Dhuhr',
    'Asr',
    'Maghrib',
    'Isha',
  ];
  void _requestLocationPermission() async {
    PermissionStatus permissionStatus = await Permission.location.request();

    if (permissionStatus.isGranted) {
      // Location permission granted
      // You can now fetch the user's location or perform location-related tasks
    } else if (permissionStatus.isDenied) {
      // Location permission denied
      print("Location permission denied");
    } else if (permissionStatus.isPermanentlyDenied) {
      // Location permission denied permanently, show a dialog or message
      _showPermissionDeniedDialog();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Location Permission Denied"),
          content: const Text(
              "Please enable location permissions in the app settings."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Open app settings to let the user enable permissions
                openAppSettings();
              },
              child: const Text("Open Settings"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  saveMethod(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('saveMethod', value);
  }

  @override
  void initState() {
    data.getCoordinates();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        backgroundColor: HexColor("#2a6e2d"),
        textStyle: const TextStyle(fontSize: 20));
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
                  margin: const EdgeInsets.only(left: 45),
                  child: Text(
                    "Prayer Times",
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
            DropdownButtonHideUnderline(
                child: DropdownButton(
              // Initial Value
              value: data.dropdownvalue,
              style: const TextStyle(color: Colors.black, fontSize: 16),
              iconSize: 24,
              elevation: 16,
              // Down Arrow Icon
              icon: const Icon(Icons.settings),

              // Array list of items
              items: items.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (String? newValue) {
                setState(() {
                  data.dropdownvalue = newValue!;
                  NotificationServices notificationServices =
                      NotificationServices();

                  notificationServices.intializationNotification();
                  // startTime();
                  notificationServices.showNotify();
                });
              },
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_pin,
                  color: HexColor("#ffde59"),
                ),
                Container(
                  child: Text(
                    (data.location == null)
                        ? 'Please allow access of location'
                        : data.location.toString(),
                    style: TextStyle(
                        color: HexColor("#ffde59"),
                        fontFamily: 'Schyler',
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            // (data.location == null)
            //     ? ElevatedButton(
            //         style: style,
            //         onPressed: (() async {
            //           _requestLocationPermission();
            //         }),
            //         child: Text('Press Button to get Access'))
            //     :
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: (data.location == null) ? 0 : prayerNames.length,
                itemBuilder: (context, index) {
                  var params =
                      CalculationMethod.NorthAmerica(); // Canada's coordinates
                  print(data.dropdownvalue);
                  saveMethod(data.dropdownvalue);

                  switch (data.dropdownvalue) {
                    case 'Dubai':
                      params = CalculationMethod.Dubai();

                      break;
                    case 'Egyptian':
                      params = CalculationMethod.Egyptian();
                      break;
                    case 'Karachi':
                      params = CalculationMethod.Karachi();
                      break;
                    case 'Kuwait':
                      params = CalculationMethod.Kuwait();
                      break;
                    case 'MoonsightingCommittee':
                      params = CalculationMethod.MoonsightingCommittee();
                      break;
                    case 'MuslimiorldLeague':
                      params = CalculationMethod.MuslimWorldLeague();
                      break;
                    case 'Qatar':
                      params = CalculationMethod.Qatar();
                      break;
                    case 'Singapore':
                      params = CalculationMethod.Singapore();
                      break;
                    case 'Tehran':
                      params = CalculationMethod.Tehran();
                      break;
                    case 'Turkey':
                      params = CalculationMethod.Turkey();
                      break;
                    case 'UmmAlQura':
                      params = CalculationMethod.UmmAlQura();
                      break;
                    case 'Other':
                      params = CalculationMethod.Other();
                      break;
                    default:
                      params = CalculationMethod.NorthAmerica();
                      break;
                  }
                  var date = DateTime.now();

                  PrayerTimes prayerTimes = PrayerTimes(
                      data.coordinates, date, params,
                      precision: true);
                  DateTime prayerTime =
                      tz.TZDateTime.from(prayerTimes.fajr!, data.location);
                  final prayerName = prayerNames[index];
                  if (prayerName == 'Fajr') {
                    prayerTime =
                        tz.TZDateTime.from(prayerTimes.fajr!, data.location);
                  }
                  if (prayerName == 'Dhuhr') {
                    prayerTime =
                        tz.TZDateTime.from(prayerTimes.dhuhr!, data.location);
                  }
                  if (prayerName == 'Asr') {
                    prayerTime =
                        tz.TZDateTime.from(prayerTimes.asr!, data.location);
                  }
                  if (prayerName == 'Maghrib') {
                    prayerTime =
                        tz.TZDateTime.from(prayerTimes.maghrib!, data.location);
                  }
                  if (prayerName == 'Isha') {
                    prayerTime =
                        tz.TZDateTime.from(prayerTimes.isha!, data.location);
                  }

                  final displayDate = DateFormat.jm().format(prayerTime);
                  return Column(
                    children: [
                      const SizedBox(
                        height: 6,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Card(
                          color: HexColor("#ffde59"),
                          child: ListTile(
                            title: Text(
                              prayerNames[index] +
                                  ':' +
                                  ' ' +
                                  displayDate.toString(),
                              style: TextStyle(
                                color: HexColor("#2a6e2d"),
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
          ],
        ),
      )),
    );
  }
}
