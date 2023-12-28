import 'package:flutter/material.dart';

class NavigationBars extends StatefulWidget {
  static int _selectedIndex = 0;

  @override
  NavigationBarState createState() => NavigationBarState();
}

class NavigationBarState extends State<NavigationBars> {
  void _onItemTapped(int index) {
    setState(() {
      NavigationBars._selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        elevation: 0, // to get rid of the shadow
        currentIndex: NavigationBars._selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
        backgroundColor: const Color(
            0x44aaaaff), // transparent, you could use 0x44aaaaff to make it slightly less transparent with a blue hue.
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.blue,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grade),
            label: 'Level',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Achievements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ]);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
