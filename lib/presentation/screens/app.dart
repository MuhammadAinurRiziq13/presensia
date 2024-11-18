import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Import for File handling
import '../widgets/bottom_app_bar.dart';
import 'home/home_page.dart';
import 'history/history_page.dart';
import 'permit/permit_page.dart';
import 'profile/profile_page.dart';
import 'presensi/presensi_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;
  File? _image; // Untuk menyimpan gambar dari kamera
  final ImagePicker _picker = ImagePicker();

  final List<Widget> _pages = [
    const HomePage(),
    const HistoryPage(),
    PresensiWidget(),
    const PermitPage(),
    const ProfilePage(),
  ];

  Future<void> _getImageFromCamera() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Menyimpan gambar dari kamera
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _pages[_currentIndex],
          if (_image != null)
            Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: Image.file(_image!,
                  height: 200), // Menampilkan gambar hasil capture
            ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 65.0,
        height: 65.0,
        child: FloatingActionButton(
          onPressed:
              _getImageFromCamera, // Aksi memanggil kamera ketika tombol ditekan
          backgroundColor: Colors.blue,
          shape: const CircleBorder(),
          child: Icon(
            Icons.camera_alt,
            color: Colors.white,
            size: 30.0,
          ),
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