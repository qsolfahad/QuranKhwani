import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qurankhwani/SurahLists.dart';
import 'package:qurankhwani/juzLists.dart';

class PageRouteJuzScreen extends StatefulWidget {
  const PageRouteJuzScreen();

  @override
  State<PageRouteJuzScreen> createState() => _PageRouteJuzScreenState();
}

class _PageRouteJuzScreenState extends State<PageRouteJuzScreen> {
  @override
  Widget build(BuildContext context) {
    return const JuzList();
    //return PageView(
    //  children: [JuzList(), SurahList()],
    //);
  }
}

class PageRouteSurahScreen extends StatefulWidget {
  const PageRouteSurahScreen();

  @override
  State<PageRouteSurahScreen> createState() => _PageRouteSurahScreenState();
}

class _PageRouteSurahScreenState extends State<PageRouteSurahScreen> {
  @override
  Widget build(BuildContext context) {
    return const SurahList();
    //return PageView(
    //  children: [JuzList(), SurahList()],
    //);
  }
}
