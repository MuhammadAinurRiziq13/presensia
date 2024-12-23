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

  // Fungsi untuk mereset gambar
  void _resetImages() {
    setState(() {
      _images.clear();
      _imageIndex = 0;
    });
  }

  // Fungsi untuk menampilkan tombol ambil gambar
  Widget _buildCaptureButton() {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterImageSuccess) {
          context.go('/login');
        }
        if (state is RegisterImageFailure) {
          context.go('/login');
        }
      },
      builder: (context, state) {
        bool isLoading = state is RegisterImageLoading;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tombol Capture/Submit
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
              ),
              onPressed: () async {
                if (_images.length < 5) {
                  await _takePicture();
                } else {
                  context.read<RegisterBloc>().add(RegisterImageEvent(
                        files:
                            _images.map((image) => File(image.path)).toList(),
                      ));
                  SharedPreferences.getInstance().then((prefs) {
                    prefs.setBool('isRegistered', true);
                  });
                  context.go('/login');
                }
              },
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      _images.length < 5 ? 'Capture Photo' : 'Submit Images',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),

            // Tombol Reset (hanya tampil jika ada gambar)
            if (_images.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Colors.blue, width: 2),
                    ),
                    elevation: 3,
                  ),
                  onPressed: _resetImages,
                  child: const Text(
                    'Reset Photos',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pendaftaran Foto",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildCameraPreview(),
              const SizedBox(height: 20),
              _buildProgressIndicator(),
              const SizedBox(height: 20),
              _buildCaptureButton(),
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
                color: Colors.blue,
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
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Transform(
                // Menambahkan transformasi untuk mencerminkan kamera
                transform:
                    Matrix4.rotationY(3.14159), // Putar 180 derajat di sumbu Y
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
              backgroundColor: Colors.white,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              minHeight: 12,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Photo Progress: ${_images.length}/5',
          style: const TextStyle(
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
