import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:presensia/presentation/blocs/register/register_bloc.dart';
import 'package:presensia/presentation/blocs/register/register_event.dart';
import 'package:presensia/presentation/blocs/register/register_state.dart';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterImage extends StatefulWidget {
  const RegisterImage({super.key});

  @override
  _RegisterImageState createState() => _RegisterImageState();
}

class _RegisterImageState extends State<RegisterImage>
    with SingleTickerProviderStateMixin {
  late CameraController _cameraController;
  bool _isCameraInitialized = false;
  bool _isTakingPhoto = false;
  late List<XFile> _images;
  int _imageIndex = 0;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _images = [];
    _initializeCamera();
    _initializeLocalNotifications();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);
    _cameraController = CameraController(frontCamera, ResolutionPreset.high);

    try {
      await _cameraController.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  // Menginisialisasi flutter local notifications
  Future<void> _initializeLocalNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Fungsi untuk menampilkan notifikasi
  Future<void> _showNotification(String message) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      importance: Importance.max,
      priority: Priority.high,
    );
    const platformDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Pendaftaran Gambar',
      message,
      platformDetails,
    );
  }

  Future<void> _takePicture() async {
    if (_cameraController.value.isInitialized && !_isTakingPhoto) {
      setState(() {
        _isTakingPhoto = true;
      });
      try {
        final file = await _cameraController.takePicture();
        setState(() {
          _images.add(file);
          _imageIndex++;
          _isTakingPhoto = false;
        });
      } catch (e) {
        setState(() {
          _isTakingPhoto = false;
        });
        print("Error taking picture: $e");
      }
    }
  }

  Widget _buildCameraPreview() {
    if (!_isCameraInitialized) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6A5ACD)),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double previewWidth = screenWidth - 40;
        double previewHeight = previewWidth * 1.4;

        return Center(
          child: Container(
            width: previewWidth,
            height: previewHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Color(0xFF6A5ACD).withOpacity(0.8),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                  offset: const Offset(0, 10),
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF6A5ACD).withOpacity(0.1),
                  Color(0xFF4B0082).withOpacity(0.1),
                ],
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CameraPreview(_cameraController),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressIndicator() {
    double progress = _images.length / 5;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6A5ACD)),
              minHeight: 12,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Photo Progress: ${_images.length}/5',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6A5ACD),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildCaptureButton() {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterImageSuccess) {
          // Tampilkan notifikasi setelah berhasil mengirim gambar
          _showNotification('Images uploaded successfully!');
        }
        if (state is RegisterImageFailure) {
          // Tampilkan notifikasi jika terjadi error
          _showNotification(state.errorMessage);
        }
      },
      builder: (context, state) {
        bool isLoading = state is RegisterImageLoading;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: LinearGradient(
              colors: [
                Color(0xFF6A5ACD),
                Color(0xFF4B0082),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF6A5ACD).withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () async {
              if (_images.length < 5) {
                await _takePicture(); // Ambil foto jika kurang dari 5
              } else {
                // Kirim gambar ke server secara asinkron
                // Pindah halaman ke login sebelum menunggu response API
                SharedPreferences.getInstance().then((prefs) {
                  prefs.setBool('isRegistered', true);
                });
                context.go('/login');

                // Kirim gambar setelah berpindah halaman
                context.read<RegisterBloc>().add(RegisterImageEvent(
                      files: _images.map((image) => File(image.path)).toList(),
                    ));
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: isLoading
                  ? const Color.fromARGB(255, 228, 228, 228)
                  : Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              minimumSize: const Size(500, 50), // Ukuran tetap untuk tombol
            ),
            child: isLoading
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : Center(
                    child: Text(
                      _images.length < 5 ? 'Capture Photo' : 'Submit Images',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Pendaftaran Foto',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF6A5ACD),
                Color(0xFF4B0082),
              ],
            ),
          ),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Pastikan wajah Anda terlihat jelas.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildCameraPreview(),
                const SizedBox(height: 30),
                _buildProgressIndicator(),
                const SizedBox(height: 30),
                _buildCaptureButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
