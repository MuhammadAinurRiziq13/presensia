import 'package:flutter/material.dart';
import '../widgets/bottom_app_bar.dart';
import 'home/home_page.dart';
import 'history/history_page.dart';
import 'permit/permit_page.dart';
import 'profile/profile_page.dart';
import 'presensi/presensi_page.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    HistoryPage(),
    PresensiWidget(), 
    PermitPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[200], // Light background color for contrast
        child: _pages[_currentIndex],
      ),
      floatingActionButton: Container(
        width: 65.0,
        height: 65.0,
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              _currentIndex =
                  2; // Set to camera page (even though it's a placeholder)
            });
          },
          backgroundColor: Colors.blue,
          child: Icon(
            Icons.camera_alt,
            color: Colors.white,
            size: 30.0,
          ),
          shape: CircleBorder(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBarWidget(
        currentIndex: _currentIndex,
        onTabSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      extendBody: true,
    );
  }
}
