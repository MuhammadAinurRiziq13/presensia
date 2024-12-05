import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:presensia/presentation/blocs/register/register_bloc.dart';
import 'package:presensia/presentation/blocs/register/register_event.dart';
import 'package:presensia/presentation/blocs/register/register_state.dart';
import 'dart:io';
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

  @override
  void initState() {
    super.initState();
    _images = [];
    _initializeCamera();
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

  // Fungsi untuk mengambil gambar
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
      }
    }
  }

  // Fungsi untuk menampilkan tombol ambil gambar
  Widget _buildCaptureButton() {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterImageSuccess) {
          // Setelah berhasil upload gambar, pindah ke halaman login
          context.go('/login');
        }
        if (state is RegisterImageFailure) {
          // Jika gagal upload gambar, pindah ke halaman login
          context.go('/login');
        }
      },
      builder: (context, state) {
        bool isLoading = state is RegisterImageLoading;
        return ElevatedButton(
          onPressed: () async {
            if (_images.length < 5) {
              await _takePicture(); // Ambil foto jika kurang dari 5
            } else {
              // Kirim gambar ke server
              context.read<RegisterBloc>().add(RegisterImageEvent(
                    files: _images.map((image) => File(image.path)).toList(),
                  ));
              // Pindah halaman setelah gambar dikirim
              SharedPreferences.getInstance().then((prefs) {
                prefs.setBool('isRegistered', true);
              });
              context.go('/login');
            }
          },
          child: isLoading
              ? CircularProgressIndicator()
              : Text(_images.length < 5 ? 'Capture Photo' : 'Submit Images'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pendaftaran Foto"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue,
                Colors.blueAccent,
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildCameraPreview(), // Menampilkan preview kamera
              const SizedBox(height: 20),
              _buildProgressIndicator(), // Menampilkan progres pengambilan gambar
              const SizedBox(height: 20),
              _buildCaptureButton(), // Menampilkan tombol untuk mengambil gambar
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan preview kamera
  Widget _buildCameraPreview() {
    if (!_isCameraInitialized) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
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
                color: Colors.blue.withOpacity(0.8),
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
                  Colors.blue.withOpacity(0.1),
                  Colors.blueAccent.withOpacity(0.1),
                ],
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Transform(
                transform: Matrix4.rotationY(0), // Menonaktifkan efek mirror
                alignment: Alignment.center,
                child: CameraPreview(_cameraController),
              ),
            ),
          ),
        );
      },
    );
  }

  // Fungsi untuk menampilkan progress pengambilan gambar
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
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
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
            color: Colors.blue,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }
}
