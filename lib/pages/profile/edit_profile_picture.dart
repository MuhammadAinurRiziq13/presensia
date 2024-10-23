import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfilePicturePage extends StatelessWidget {
  final Function(File?) onImagePicked;

  const EditProfilePicturePage({super.key, required this.onImagePicked});

  @override
  Widget build(BuildContext context) {
    final ImagePicker picker = ImagePicker();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Foto Profil'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final XFile? image =
                await picker.pickImage(source: ImageSource.gallery);
            if (image != null) {
              onImagePicked(
                  File(image.path)); // Kirim gambar kembali ke ProfilePage
              Navigator.of(context).pop(); // Kembali ke halaman profil
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tidak ada gambar yang dipilih')),
              );
            }
          },
          child: const Text('Pilih Gambar dari Galeri'),
        ),
      ),
    );
  }
}
