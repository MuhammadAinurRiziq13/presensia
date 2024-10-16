// import 'package:flutter/material.dart';

// class PermitPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(child: Text('Permit Page'));
//   }
// }

import 'package:flutter/material.dart';
import 'permit_request_page.dart'; // Import the PermitRequestPage

class PermitPage extends StatefulWidget {
  const PermitPage({super.key});

  @override
  _PermitPageState createState() => _PermitPageState();
}

class _PermitPageState extends State<PermitPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Permit',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.mail_outline, color: Colors.blue),
                    title: Text('Perizinan'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navigate to PermitRequestPage when tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PermitRequestPage(),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Divider(height: 1, thickness: 1),
                  ),
                  ListTile(
                    leading: Icon(Icons.history, color: Colors.blue),
                    title: Text('Riwayat Perizinan'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Define navigation for Riwayat Perizinan if needed
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//   int _currentIndex = 3; // Set to 3 to open the PermitPage initially

//   final List<Widget> _pages = [
//     HomePage(),
//     HistoryPage(),
//     PlaceholderWidget(), // Placeholder for the Camera
//     PermitMainPage(), // PermitMainPage opened by default
//     ProfilePage(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.only(bottom: 56.0), // Space for the BottomNavigationBar
//         child: _pages[_currentIndex],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             _currentIndex = 2; // Set to camera page (even though it's a placeholder)
//           });
//         },
//         backgroundColor: Colors.blue,
//         child: const Icon(Icons.camera_alt, color: Colors.white),
//         shape: const CircleBorder(), // Make the button circular
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           if (index != 2) {
//             // Avoid navigation when tapping the camera
//             setState(() {
//               _currentIndex = index;
//             });
//           }
//         },
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//         type: BottomNavigationBarType.fixed,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.history),
//             label: 'History',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(null), // Empty icon for the camera
//             label: '', // Empty label for the camera
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.perm_contact_calendar),
//             label: 'Permit',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Placeholder for each page in the navigation
// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text('Home Page'));
//   }
// }

// class HistoryPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text('History Page'));
//   }
// }

// class PermitMainPage extends StatelessWidget {
//   const PermitMainPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Permit'),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         titleTextStyle: const TextStyle(
//           color: Colors.black,
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//         ),
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12.0),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 10,
//                     offset: Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   ListTile(
//                     leading: Icon(Icons.mail_outline, color: Colors.blue),
//                     title: Text('Perizinan'),
//                     trailing: Icon(Icons.arrow_forward_ios),
//                     onTap: () {
//                       // Navigate to PermitRequestPage when tapped
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => PermitRequestPage(),
//                         ),
//                       );
//                     },
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                     child: Divider(height: 1, thickness: 1),
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.history, color: Colors.blue),
//                     title: Text('Riwayat Perizinan'),
//                     trailing: Icon(Icons.arrow_forward_ios),
//                     onTap: () {
//                       // Define navigation for Riwayat Perizinan if needed
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ProfilePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text('Profile Page'));
//   }
// }

// class PlaceholderWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text('Camera Placeholder'));
//   }
// }
