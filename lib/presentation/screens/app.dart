// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io'; // Import for File handling
// import '../widgets/bottom_app_bar.dart';
// import 'home/home_page.dart';
// import 'history/history_page.dart';
// import 'permit/permit_page.dart';
// import 'profile/profile_page.dart';
// import 'presensi/presensi_page.dart';
// import 'package:presensia/data/datasources/history_api_datasource.dart';
// import 'package:presensia/data/repositories/history_repository_impl.dart';
// import 'package:presensia/domain/usecases/history_usecase.dart';
// import 'package:presensia/presentation/blocs/history/history_bloc.dart';
// import 'package:presensia/core/utils/dio_client/dio_client.dart';
// import 'package:presensia/core/utils/constants.dart';

// class App extends StatefulWidget {
//   const App({super.key});

//   @override
//   _AppState createState() => _AppState();
// }

// class _AppState extends State<App> {
//   int _currentIndex = 0;
//   File? _image; // For storing the image from the camera
//   final ImagePicker _picker = ImagePicker();
//   late final HistoryBloc _historyBloc;

//   @override
//   void initState() {
//     super.initState();
//     _historyBloc = HistoryBloc(
//       GetHistoryUseCase(
//         HistoryRepositoryImpl(
//           HistoryApiDataSource(DioClient(baseUrl: Constants.baseUrl).client),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _historyBloc.close();
//     super.dispose();
//   }

//   Future<void> _getImageFromCamera() async {
//     final XFile? pickedFile =
//         await _picker.pickImage(source: ImageSource.camera);

//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path); // Store the image from the camera
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final List<Widget> _pages = [
//       const HomePage(),
//       const HistoryPage(),
//       const PresensiPage(),
//       const PermitPage(),
//       const ProfilePage(),
//     ];

//     return BlocProvider<HistoryBloc>(
//       create: (_) => _historyBloc,
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: Stack(
//           children: [
//             _pages[_currentIndex],
//             if (_image != null)
//               Positioned(
//                 bottom: 100,
//                 left: 20,
//                 right: 20,
//                 child: Image.file(
//                   _image!,
//                   height: 200,
//                 ), // Display captured image
//               ),
//           ],
//         ),
//         floatingActionButton: SizedBox(
//           width: 65.0,
//           height: 65.0,
//           child: FloatingActionButton(
//             onPressed: _getImageFromCamera, // Capture image when button pressed
//             backgroundColor: Colors.blue,
//             shape: const CircleBorder(),
//             child: const Icon(
//               Icons.camera_alt,
//               color: Colors.white,
//               size: 30.0,
//             ),
//           ),
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//         bottomNavigationBar: BottomAppBarWidget(
//           currentIndex: _currentIndex,
//           onTabSelected: (index) {
//             setState(() {
//               _currentIndex = index;
//             });
//           },
//         ),
//         extendBody: true,
//       ),
//     );
//   }
// }
