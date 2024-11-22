// import 'package:flutter/material.dart';

// class BottomAppBarWidget extends StatelessWidget {
//   final int currentIndex;
//   final ValueChanged<int> onTabSelected;

//   const BottomAppBarWidget({
//     Key? key,
//     required this.currentIndex,
//     required this.onTabSelected,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BottomAppBar(
//       color: Colors.white,
//       elevation: 10.0,
//       notchMargin: 10.0,
//       shape: CircularNotchedRectangle(),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           _buildBottomNavItem(Icons.home, 'Home', 0),
//           _buildBottomNavItem(Icons.history, 'History', 1),
//           SizedBox(width: 40), // Space for the FloatingActionButton
//           _buildBottomNavItem(Icons.mail, 'Permit', 3),
//           _buildBottomNavItem(Icons.person, 'Profile', 4),
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomNavItem(IconData icon, String label, int index) {
//     return GestureDetector(
//       onTap: () {
//         onTabSelected(index);
//       },
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Icon(
//             icon,
//             color: currentIndex == index ? Colors.blue : Colors.grey,
//             size: 30.0,
//           ),
//           SizedBox(height: 4.0),
//           Text(
//             label,
//             style: TextStyle(
//               color: currentIndex == index ? Colors.blue : Colors.grey,
//               fontSize: 12.0,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }