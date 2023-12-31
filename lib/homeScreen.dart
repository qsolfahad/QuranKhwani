import 'dart:io';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:qurankhwani/GameLists.dart';
import 'package:qurankhwani/bookmark_page.dart';
import 'package:qurankhwani/duaLists.dart';
import 'package:qurankhwani/notify.dart';
import 'package:qurankhwani/pageRoute.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:qurankhwani/RecordPage.dart';
import 'package:qurankhwani/group_screen.dart';
import 'package:qurankhwani/intro_name.dart';
import 'package:qurankhwani/SurahLists.dart';
import 'package:qurankhwani/juzLists.dart';
import 'package:qurankhwani/juzPageView.dart';
import 'package:qurankhwani/prayerTimeList.dart';
import 'package:qurankhwani/qaidaLists.dart';
import 'package:qurankhwani/main.dart';
import 'package:quantity_input/quantity_input.dart';
import 'package:qurankhwani/wordsMeaningList.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// Future<void> saveAndUploadToFirebaseStorage() async {
//   // Get the local app directory
//   // List<String> listOfWords;
//   Directory appDocDir = await getApplicationDocumentsDirectory();
//   String appDocPath = appDocDir.path;
//   var datalist = [
//    ];
//   // Create a new Excel workbook and sheet
//   var excel = Excel.createExcel();
//   var sheet = excel['Sheet1'];
//   var count = 0;
//   // Add data to the sheet
//   sheet.appendRow(['Quranic Words']);
// //  await FirebaseFirestore.instance
//   //    .collection('Ayahs')
//   //   .orderBy('totalverse')
//   //  .get()
//   //  .then((value) => value.docs.forEach((element) {
//   //var ayah = element.data()['verse'].toString();
//   //var ayaSplit = ayah.split('|');
//   //   var ayaSplits = ayah.replaceAll('وَ|', 'وَ');
//   //  var ayaSplitss = ayaSplits.replaceAll('وْ|', 'وْ');
//   //  var ayaSplitsss = ayaSplitss.replaceAll('وَّ|', 'وَّْ');
//   // String modifiedText = ayaSplits.replaceAllMapped(
//   //     RegExp(r'ۙ|۝'), (match) => '|${match.group(0)}');
//   // for (var i = 0; i < ayaSplit.length; i++)
//   List<String> unique = [];
//   for (var i = 0; i < datalist.length; i++) {
//     var data = datalist[i]['verse'].toString();
//     var dataSplit = data.split(' ');
//     for (var j = 0; j < dataSplit.length; j++) {
//       unique.add(dataSplit[j]);
//       if (unique.contains(dataSplit[j])) {
//         sheet.appendRow([dataSplit[j]]);
//       }
//     }

//     count++;
//     print(count);
//   }

//   //    }));

//   // Generate a file name and path
//   String fileName = 'Arabic Words.xlsx';
//   String filePath = '$appDocPath/$fileName';

//   // Save the Excel file
//   File file = File(filePath);
//   await file.writeAsBytes(await excel.save()!);

//   print('Excel file saved at: $filePath');

//   // Upload the Excel file to Firebase Storage
//   Reference storageRef = FirebaseStorage.instance
//       .ref()
//       .child('excel_files/${path.basename(filePath)}');
//   await storageRef.putFile(file);

//   print('Excel file uploaded to Firebase Storage.');
// }

// Surah Variables
var surahNameList = <String>[];
var surahNo = <String>[];
var surahAyah = <String>[];
var surahPages = <String>[];
var surahEndPages = <String>[];
var surahCount = {};
var surahArabicNameList = <String>[];
var _selectedIndex = 0;
var DuaNames = <String>[];
var DuaNo = <String>[];
Map<String, Map<String, String>> elements = {};
Map<String, Map<String, String>> meanings = {};
Map<String, Map<String, String>> EnglishMeanings = {};
var pageLength = 0;
List<String> wordsToFindrange = [];
List<String> ArabicWordsToFindrange = [];
List<String> wordsToFind = [];
List<String> ArabicWordsToFind = [];
Map<int, int> rowlenght = {};
Map<int, String> instruction = {};
Map<String, String> section = {};
Map<String, int> record = {};
// Juz Variables
var JuzNameList = <String>[];
var JuzNo = <String>[];
var JuzAyah = <String>[];
var JuzPages = <String>[];
var JuzEndPages = <String>[];
var JuzCount = {};
var JuzArabicNameList = <String>[];

class Wordle {
  final String arabic;
  final String meaning;

  Wordle({required this.arabic, required this.meaning});
}

final List<Wordle> wordle = [];
//location variables
loadwords() async {
  // Replace your existing code with the modified code below:

// Replace your existing code with the modified code below:

  QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('words').get();

// Shuffle the documents randomly
  List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
      querySnapshot.docs.toList();
  documents.shuffle(Random());

// Retrieve the English meanings from the shuffled documents
  documents.take(50).forEach((doc) {
    wordle.add(Wordle(
        arabic: doc.data()['Arabic Word'].toString(),
        meaning: doc.data()['English Meaning'].toString()));
    wordsToFindrange
        .add(doc.data()['English Meaning'].toString().toUpperCase());
    ArabicWordsToFindrange.add(doc.data()['Arabic Word'].toString());
  });

  var rng = Random();
  for (var i = 0; i < 5; i++) {
    var int = rng.nextInt(49);
    wordsToFind.add(wordsToFindrange[int]);
    ArabicWordsToFind.add(ArabicWordsToFindrange[int]);
  }
}

class _MyHomePageState extends State<MyHomePage> {
  // getdata() async {
  //   List data = [

  //   ];
  //   print("working");
  //   for (int i = 0; i < data.length; i++) {
  //     await FirebaseFirestore.instance.collection('QuranWords').add({
  //       "Record Number": data[i]['Record Number'],
  //       "Words": data[i]['Words'],
  //       "Meaning": data[i]['Meaning'],
  //       "Root": (data[i]['Root'] != null) ? data[i]['Root'] : "",
  //       "Surah": data[i]['Surah'],
  //       "Ayah": data[i]['Ayah']
  //     });
  //     // await FirebaseFirestore.instance.collection("Ayahs").where('totalverse', isEqualTo: data[i]['totalverse']).get().then((value) {
  //     //   value.docs.forEach((element) {
  //     //   //  print(element.id);
  //     //      FirebaseFirestore.instance.collection("Ayahs").doc(element.id).update({
  //     //       'verse': data[i]['verse']
  //     //      });
  //     //   });
  //     // },);
  //     print(i);
  //   }
  // }

  // getdata() async {
  //   List data = [

  //   ];
  //   print("working");
  //   for (int i = 0; i < data.length; i++) {
  //     await FirebaseFirestore.instance.collection('QuranWords').add({
  //       "Record Number": data[i]['Record Number'],
  //       "Words": data[i]['Words'],
  //       "Meaning": data[i]['Meaning'],
  //       "Root": (data[i]['Root'] != null) ? data[i]['Root'] : "",
  //       "Surah": data[i]['Surah'],
  //       "Ayah": data[i]['Ayah']
  //     });
  //     // await FirebaseFirestore.instance.collection("Ayahs").where('totalverse', isEqualTo: data[i]['totalverse']).get().then((value) {
  //     //   value.docs.forEach((element) {
  //     //   //  print(element.id);
  //     //      FirebaseFirestore.instance.collection("Ayahs").doc(element.id).update({
  //     //       'verse': data[i]['verse']
  //     //      });
  //     //   });
  //     // },);
  //     print(i);
  //   }
  // }

  // getdata() async {
  //   List data = [

  //   ];
  //   print("working");
  //   for (int i = 0; i < data.length; i++) {
  //     // var meaning = '';
  //     // var meaningEng = '';
  //     // if(data[i]['meaning'] != null){
  //     //   meaning = data[i]['meaning'];
  //     // }
  //     // if(data[i]['englishMeaning'] != null){
  //     //  meaningEng = data[i]['englishMeaning'];
  //     // }
  //     //   await FirebaseFirestore.instance.collection('Qaida').add(
  //     //     {
  //     //       "Record": i +1,
  //     //        "element": data[i]['element'],
  //     //       "page": data[i]['page'],
  //     //       "row": data[i]['row'],
  //     //       "Column": data[i]['Column'],
  //     //       "instruction": data[i]['instruction'],
  //     //       "meaning": meaning,
  //     //       "Section": data[i]['Section'],
  //     //       "englishMeaning": meaningEng
  //     //     }
  //     //   );
  //     // await FirebaseFirestore.instance
  //     //     .collection("Ayahs")
  //     //     .where('totalverse', isEqualTo: data[i]['totalverse'])
  //     //     .get()
  //     //     .then(
  //     //   (value) {
  //     //     value.docs.forEach((element) {
  //     //       //  print(element.id);
  //     //       FirebaseFirestore.instance
  //     //           .collection("Ayahs")
  //     //           .doc(element.id)
  //     //           .update({'verse': data[i]['QuranicVerse']});
  //     //     });
  //     //   },
  //     //);
  //     //  print(data[i]['totalverse']);

  //     await FirebaseFirestore.instance
  //         .collection('Qaida')
  //         .where('element', isEqualTo: data[i]['element'])
  //         .get()
  //         .then((value) => value.docs.forEach((element) {
  //               FirebaseFirestore.instance
  //                   .collection('Qaida')
  //                   .doc(element.id)
  //                   .update({'meaning': data[i]['meaning']});
  //             }));
  //     print(i);
  //   }
  // }

  addwords() async {
    print('working');
    var data = [];
    for (int i = 0; i < data.length; i++) {
      await FirebaseFirestore.instance.collection('words').add({
        "Record": i + 1,
        "Arabic Word": data[i]['Arabic Word'],
        "English Meaning": data[i]['English Meaning'],
        "Urdu Meaning": data[i]['Urdu Meaning']
      });
      print('working' + i.toString());
    }
  }

  saveTextFont(double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('saveTextFont', value);
  }

  saveArabicTextFont(double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('saveArabictextFont', value);
  }

  delete() async {
    await FirebaseFirestore.instance
        .collection('Qaida')
        .where('page', isEqualTo: 3)
        .get()
        .then((value) => value.docs.forEach((element) {
              FirebaseFirestore.instance
                  .collection('Qaida')
                  .doc(element.id)
                  .delete();
            }));
  }

  bool isOpened = false;

  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  final GlobalKey<SideMenuState> _endSideMenuKey = GlobalKey<SideMenuState>();

  toggleMenu([bool end = false]) {
    if (end) {
      final _state = _endSideMenuKey.currentState!;
      if (_state.isOpened) {
        _state.closeSideMenu();
      } else {
        _state.openSideMenu();
      }
    } else {
      final _state = _sideMenuKey.currentState!;
      if (_state.isOpened) {
        _state.closeSideMenu();
      } else {
        _state.openSideMenu();
      }
    }
  }

  void setUserRecord() async {
    Map<String, dynamic> arr = {};
    var uservalue = await FirebaseAuth.instance.signInAnonymously();
    var doc = FirebaseFirestore.instance.collection("UserRecord");
    var doc1 =
        FirebaseFirestore.instance.collection("JuzLists").orderBy("Para");
    await FirebaseFirestore.instance
        .collection("UserRecord")
        .where("UserId", isEqualTo: uservalue.user?.uid)
        .where('name', isEqualTo: 'juz')
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        arr.addAll({"UserId": uservalue.user?.uid});
        arr.addAll({"name": 'juz'});
        doc1.get().then((value) {
          for (var element in value.docs) {
            arr.addAll({"${element.data()["Translation"]}": 0});
          }
          doc.add(arr);
        });

        // doc.add(arr);
      }
    });
  }

  void getDuaList() async {
    await FirebaseFirestore.instance
        .collection('Duas')
        .orderBy('duaNo')
        .get()
        .then((value) {
      for (var element in value.docs) {
        DuaNames.add(element.data()['duaName']);
        DuaNo.add(element.data()['duaNo'].toString());
      }
    });
  }

  void setSurahUserRecord() async {
    Map<String, dynamic> arr = {};
    var uservalue = await FirebaseAuth.instance.signInAnonymously();
    var doc = FirebaseFirestore.instance.collection("UserRecord");
    var doc1 =
        FirebaseFirestore.instance.collection("SurahLists").orderBy("index");
    await FirebaseFirestore.instance
        .collection("UserRecord")
        .where("UserId", isEqualTo: uservalue.user?.uid)
        .where('name', isEqualTo: 'surah')
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        arr.addAll({"UserId": uservalue.user?.uid});
        arr.addAll({"name": 'surah'});
        doc1.get().then((value) {
          for (var element in value.docs) {
            arr.addAll({"${element.data()["title"]}": 0});
          }
          doc.add(arr);
        });

        // doc.add(arr);
      }
    });
  }

  void getSurahList() async {
    var uservalue = await FirebaseAuth.instance.signInAnonymously();
    var doc = FirebaseFirestore.instance
        .collection("UserRecord")
        .where("UserId", isEqualTo: uservalue.user?.uid)
        .where('name', isEqualTo: 'surah');
    await FirebaseFirestore.instance
        .collection("SurahLists")
        .orderBy("index")
        .get()
        .then((value) => value.docs.forEach((element) {
              doc.get().then((value1) {
                for (var element1 in value1.docs) {
                  surahCount.addAll({
                    "${element.data()["title"]}":
                        element1.data()[element.data()["title"]].toString()
                  });
                }
              });
              surahNameList.add(element.data()["title"]);
              surahArabicNameList.add(element.data()["titleAr"]);
              surahNo.add(element.data()["index"].toString());
              surahAyah.add(element.data()["count"].toString());
              surahPages.add(element.data()["pages"].toString());
              surahEndPages.add(element.data()["endPages"].toString());
              //duplicateItems =
              //   List<String>.generate(114, (i) => );
            }));
  }

  void getQaida() async {
    Map<String, String> mapElement = {};
    Map<String, String> mapMeaning = {};
    Map<String, String> mapEnglishMeaning = {};
    List unique = [];
    await FirebaseFirestore.instance
        .collection('Qaida')
        .orderBy('Record')
        .get()
        .then((value) {
      for (var element in value.docs) {
        var ele = element.data()['element'];
        var meaning = element.data()['meaning'];
        var englishMeaning = element.data()['englishMeaning'];
        var row = element.data()['row'];
        var col = element.data()['Column'];
        var page = element.data()['page'];
        final entryr = <String, int>{
          page.toString() + ',' + row.toString(): element.data()['Record']
        };
        final entry = <String, String>{
          page.toString() + ',' + row.toString():
              element.data()['Section'].toString()
        };
        section.addEntries(entry.entries);
        record.addEntries(entryr.entries);
        if (rowlenght[page] == null) {
          rowlenght.putIfAbsent(page, () => row);
        } else {
          rowlenght.update(page, (value) => row);
        }
        instruction.putIfAbsent(page, () => element.data()['instruction']);
        pageLength = page;
        mapElement.putIfAbsent(
            page.toString() + ',' + col.toString(), () => ele);
        mapMeaning.putIfAbsent(
            page.toString() + ',' + col.toString(), () => meaning);
        mapEnglishMeaning.putIfAbsent(
            page.toString() + ',' + col.toString(), () => englishMeaning);
        if (unique.contains(page.toString() + ',' + row.toString())) {
          elements.putIfAbsent(
              page.toString() + ',' + row.toString(), () => mapElement);
          meanings.putIfAbsent(
              page.toString() + ',' + row.toString(), () => mapMeaning);
          EnglishMeanings.putIfAbsent(
              page.toString() + ',' + row.toString(), () => mapEnglishMeaning);
        } else {
          if (unique.isNotEmpty) {
            mapElement = {};
            mapMeaning = {};
            mapEnglishMeaning = {};
            mapElement.putIfAbsent(
                page.toString() + ',' + col.toString(), () => ele);
            mapMeaning.putIfAbsent(
                page.toString() + ',' + col.toString(), () => meaning);
            mapEnglishMeaning.putIfAbsent(
                page.toString() + ',' + col.toString(), () => englishMeaning);
          }
          unique.add(page.toString() + ',' + row.toString());
        }
      }
    });
    // print(rowlenght);
    // print(elements['3,10']);
  }

  void getJuzList() async {
    var uservalue = await FirebaseAuth.instance.signInAnonymously();

    var doc = FirebaseFirestore.instance
        .collection("UserRecord")
        .where("UserId", isEqualTo: uservalue.user?.uid)
        .where('name', isEqualTo: 'juz');
    await FirebaseFirestore.instance
        .collection("JuzLists")
        .orderBy("Para")
        .get()
        .then((value) => value.docs.forEach((element) {
              //   print(element.data()["title"]);
              doc.get().then((value1) {
                for (var element1 in value1.docs) {
                  JuzCount.addAll({
                    "${element.data()["Translation"]}": element1
                        .data()[element.data()["Translation"]]
                        .toString()
                  });
                }
              });
              JuzNameList.add(element.data()["Translation"]);
              JuzArabicNameList.add(element.data()["Name"]);
              JuzNo.add(element.data()["Para"].toString());
              JuzPages.add(element.data()["start"].toString());
              JuzEndPages.add(element.data()["end"].toString());
              //duplicateItems =
              //   List<String>.generate(114, (i) => );
            }));
  }

  // intro() {
  //   Navigator.pushReplacement(
  //       context, MaterialPageRoute(builder: (context) => IntroName()));
  // }

  // route() {
  //   Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => MyHomePage(
  //                 title: 'Quran Khwani',
  //               )));
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
  NotificationServices notificationServices = NotificationServices();
  getUserName() async {
    var uservalue = await FirebaseAuth.instance.signInAnonymously();
    var querySnapshot = await FirebaseFirestore.instance
        .collection("Users")
        .where("userID", isEqualTo: uservalue.user?.uid)
        .get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      url = File(allData[0]['image']);
      myName = allData[0]['userName'];
    });
  }

  @override
  void initState() {
    //  saveAndUploadToFirebaseStorage();
    //getdata();
    getMethod();
    getFontSize();
    getArabicFontSize();
    getUserName();
    getUserId();

    getCoordinates();
    getLocationFromCache();
    notificationServices.intializationNotification();
    // startTime();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        notificationServices.showNotify();
      });
    });

    getQaida();
    loadwords();
    getDuaList();
    setUserRecord();
    setSurahUserRecord();
    getJuzList();
    getSurahList();
    //delete();
    // getdata();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _today = HijriCalendar.now();
    return SideMenu(
      key: _endSideMenuKey,
      inverse: true, // end side menu
      background: Colors.green[700],
      type: SideMenuType.slideNRotate,
      menu: Padding(
        padding: const EdgeInsets.only(left: 25.0),
        child: buildMenu(context),
      ),
      onChange: (_isOpened) {
        setState(() => isOpened = _isOpened);
      },
      child: SideMenu(
        background: Colors.green,
        key: _sideMenuKey,
        menu: buildMenu(context),
        type: SideMenuType.slideNRotate,
        onChange: (_isOpened) {
          setState(() => isOpened = _isOpened);
        },
        child: IgnorePointer(
          ignoring: isOpened,
          child: SafeArea(
            child: Scaffold(

             backgroundColor: HexColor('F5F9FC'),
              body: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(alignment: Alignment.topLeft,child: IconButton(onPressed: () => toggleMenu(), icon: ImageIcon(AssetImage('assets/image/drawer.png')))),
                                            Spacer(flex: 2,),
                         Container(child: Text("Main Menu",style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                fontSize: 20,
                                color: HexColor('#2a6e2d'),
                                fontWeight: FontWeight.bold)),),),
                         Spacer(flex: 2,),
                                           Container(alignment: Alignment.topLeft,child: IconButton(onPressed: (){ showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  scrollable: true,
                                  title: const Text('Options'),
                                  content: StatefulBuilder(
                                    // You need this, notice the parameters below:
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return Column(
                                          // Then, the content of your dialog.
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            QuantityInput(
                                                step: 10,
                                                maxValue: 60,
                                                minValue: 10,
                                                label: 'Text Font Size',
                                                value: textFontSize,
                                                onChanged: (value) =>
                                                    setState(() {
                                                      textFontSize =
                                                          double.parse(
                                                              value.replaceAll(
                                                                  ',', ''));
                                                      saveTextFont(double.parse(
                                                          value.replaceAll(
                                                              ',', '')));
                                                    })),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            QuantityInput(
                                                step: 10,
                                                maxValue: 60,
                                                minValue: 20,
                                                label: 'Arabic Text Font Size',
                                                value: arabictextFontSize,
                                                onChanged: (value) =>
                                                    setState(() {
                                                      arabictextFontSize =
                                                          double.parse(
                                                              value.replaceAll(
                                                                  ',', ''));
                                                      saveArabicTextFont(
                                                          double.parse(
                                                              value.replaceAll(
                                                                  ',', '')));
                                                    })),
                                          ]);
                                    },
                                  ));
                            },
                          );}, icon: Icon(Icons.settings))),
                                       
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                     Container(
  width: 357,
  height: 178,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(25),
    gradient: LinearGradient(
      colors: [Colors.green[100]!, Colors.blue[100]!], // You can customize the colors
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  child: Row(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 30, left: 30),
            child: Text(
              'Last \nListening',
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  fontSize: 20,
                  color: HexColor('#2a6e2d'),
                  fontWeight: FontWeight.w800
                ),
              ),
            ),
          ),
          Spacer(),
          //  Container(
          //   margin: EdgeInsets.only(top: 20, left: 30),
          //   child: Text(
          //     'Al-Fatiha',
          //     style: GoogleFonts.montserrat(
          //       textStyle: TextStyle(
          //         fontSize: 16,
          //         color: HexColor('#2a6e2d'),
          //         fontWeight: FontWeight.w500
          //       ),
          //     ),
          //   ),
          // ),
          //  Container(
          //   margin: EdgeInsets.only( left: 30),
          //   child: Text(
          //     'Page no: 1',
          //     style: GoogleFonts.montserrat(
          //       textStyle: TextStyle(
          //         fontSize: 12,
          //         color: HexColor('#2a6e2d'),
          //         fontWeight: FontWeight.w500
          //       ),
          //     ),
          //   ),
          // ),
           GestureDetector(
            onTap: () async{
 var value = await FirebaseAuth.instance.signInAnonymously();
              await FirebaseFirestore.instance
                  .collection("ListView")
                  .where("userId", isEqualTo: value.user?.uid)
                  .orderBy("createdDate", descending: true)
                  .limit(1)
                  .get()
                  .then((value) => value.docs.forEach((element) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => JuzPageView(
                                  element.data()["surahName"],
                                  element.data()["surahNo"],
                                  element.data()["surahAyah"],
                                  element.data()["surahPage"],
                                  element.data()["surahEndPage"],
                                  '',
                                  element.data()["currentPosition"],
                                  Colors.black)),
                        );

                        //duplicateItems =
                        //   List<String>.generate(114, (i) => );
                      }));
            },
             child: Container(
              width: 120,
              height: 33,
             
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white,),
              margin: EdgeInsets.only(top: 20,  left: 30),
              child: Center(
                child: Text(
                  'Continue',
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      fontSize: 12,
                      color: HexColor('#2a6e2d'),
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              ),
                       ),
           ),
           SizedBox(height: 20,
           )
        ],
      ),
      Spacer(),
      Container(
        padding: const EdgeInsets.all(16.0),
        child: Image.asset(
          "assets/image/Qurankhwani.png",
          width: 170,
          height: 170,
        ),
      ),
    ],
  ),
),

                      // Image.asset(
                      //   "assets/image/Qurankhwani.png",
                      //   height: 200,
                      // ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          _today.toFormat("MMMM dd yyyy"),
                          style: GoogleFonts.montserrat(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: HexColor("#2a6e2d"),
                              ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: MediaQuery.of(context).size.shortestSide,
                         // constrain height
                          child: GridView.count(
                              crossAxisCount: 2,
                              //physics: const NeverScrollableScrollPhysics(),
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 16.0,
                              children: List.generate(choices.length, (index) {
                                return Center(
                                  child: SelectCard(choice: choices[index]),
                                );
                              })),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildMenu(context) {
  return Padding(
    padding: const EdgeInsets.only(left: 19),
    child: Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CircleAvatar(
            //   radius: 60,
            //   backgroundColor: Color(0xffFDCF09),
            //   child: main.url != null
            //       ? ClipRRect(
            //           borderRadius: BorderRadius.circular(50),
            //           child: Image.file(
            //             main.url,
            //             width: 100,
            //             height: 100,
            //             fit: BoxFit.cover,
            //           ),
            //         )
            //       : Container(
            //           decoration: BoxDecoration(
            //               color: Colors.grey[200],
            //               borderRadius: BorderRadius.circular(50)),
            //           width: 100,
            //           height: 100,
            //           child: Icon(
            //             Icons.camera_alt,
            //             color: Colors.grey[800],
            //           ),
            //         ),
            // ),
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
                'Juz List',
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
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const SurahList();
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
              onTap: () async {
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

class Choice {
  const Choice(
      {required this.title,
      required this.image,
      required this.value,
      required this.color});
  final String title;
  final String image;
  final String value;
  final String color;
}

const List<Choice> choices = <Choice>[
  Choice(
      title: 'AlQuran',
      image: "assets/image/allquran.png",
      value: "AlQuran",
      color: '#f5f5f5'),
  Choice(
      title: 'Total Count',
      image: "assets/image/count.png",
      value: "Count",
      color: '#ffffff'),
 
  Choice(
      title: 'Groups',
      image: "assets/image/group.png",
      value: "Groups",
      color: '#ffffff'),
  Choice(
      title: 'Duas',
      image: "assets/image/dua.png",
      value: "Duas",
      color: '#ffffff'),
  Choice(
      title: 'Qaida',
      image: "assets/image/qaida.png",
      value: "Qaida",
      color: 'ffffff'),
  Choice(
      title: 'Games',
      image: "assets/image/game.png",
      value: "Game",
      color: 'ffffff'),
  Choice(
      title: 'Prayer Time',
      image: "assets/image/prayer.png",
      value: "Prayer Time",
      color: 'ffffff'),
  Choice(
      title: 'Quranic Words',
      image: "assets/image/words.png",
      value: "Words Meaning",
      color: 'ffffff'),
];

class SelectCard extends StatelessWidget {
  const SelectCard({Key? key, required this.choice}) : super(key: key);
  final Choice choice;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          var choiceValue = choice.value;
          switch (choiceValue) {
            case "AlQuran":
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PageRouteJuzScreen()),
              );
              break;
           
            case "Count":
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RecordJuzPage()),
              );
              break;
            case "Groups":
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
              break;
            case "Duas":
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DuaLists()),
              );
              break;
            case "Qaida":
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QaidaLists()),
              );
              break;
            case "Game":
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
                  MaterialPageRoute(builder: (context) => IntroName('game')),
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
                    MaterialPageRoute(builder: (context) => IntroName('game')),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GameLists()),
                  );
                }
              }

              break;
            case "Prayer Time":
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrayerTime()),
              );
              break;
            case "Words Meaning":
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const WordMeaningList()),
              );
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
          child: Container(
              //elevation: 5,
                
             decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),color: Colors.white),
              child: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Image.asset(
                          choice.image,
                          height: 200,
                        ),
                      ),
                      Text(
                        choice.title,
                        style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  fontSize: 20,
                  color: HexColor('#2a6e2d'),
                
                ),
              ), //#a79162
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ]),
              )),
        ));
  }
}
