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
      resizeToAvoidBottomInset: false, // Tambahkan ini agar tombol tetap fixed
      body: Container(
        color: Colors.grey[200],
        child: _pages[_currentIndex],
      ),
      floatingActionButton: Container(
        width: 65.0,
        height: 65.0,
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              _currentIndex = 2; // Set to camera page (Presensi page)
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

// import 'package:flutter/material.dart';
// import '../widgets/bottom_app_bar.dart';
// import 'home/home_page.dart';
// import 'history/history_page.dart';
// import 'permit/permit_page.dart';
// import 'profile/profile_page.dart';
// import 'presensi/presensi_page.dart';

// class App extends StatefulWidget {
//   @override
//   _AppState createState() => _AppState();
// }

// class _AppState extends State<App> {
//   int _currentIndex = 0;

//   final List<Widget> _pages = [
//     HomePage(),
//     HistoryPage(),
//     PresensiWidget(),
//     PermitPage(),
//     ProfilePage(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset:
//           false, // Untuk mencegah perubahan posisi tombol kamera
//       body: Container(
//         color: Colors.grey[200],
//         child: _pages[_currentIndex],
//       ),
//       bottomNavigationBar: BottomAppBarWidget(
//         currentIndex: _currentIndex,
//         onTabSelected: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         onCameraPressed: () {
//           setState(() {
//             _currentIndex = 2; // Arahkan ke halaman presensi (tombol kamera)
//           });
//         },
//       ),
//       extendBody: true,
//     );
//   }
// }
