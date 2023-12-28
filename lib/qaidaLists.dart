import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:qurankhwani/QaidaPageView.dart';
import 'package:qurankhwani/main.dart';
import 'package:qurankhwani/homeScreen.dart' as data;

class QaidaLists extends StatefulWidget {
  const QaidaLists({super.key});

  @override
  State<QaidaLists> createState() => _QaidaListsState();
}

class _QaidaListsState extends State<QaidaLists> {
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
                    "Qaida Lists",
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
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: data.pageLength,
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
                                builder: (context) => QaidaPageView(index + 1)),
                          );
                        },
                        child: Card(
                          color: HexColor("#ffde59"),
                          child: ListTile(
                            title: Text(
                              'Lesson No ' + (index + 1).toString(),
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
          ],
        ),
      )),
    );
  }
}
