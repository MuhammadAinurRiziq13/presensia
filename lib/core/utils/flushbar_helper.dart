import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

// Menampilkan Flushbar sukses
void showSuccessFlushbar(BuildContext context, String message) {
  Flushbar(
    title: 'Berhasil',
    message: message,
    icon: const Icon(
      Icons.check_circle,
      color: Colors.white,
    ),
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.green.shade600,
    borderRadius: BorderRadius.circular(8),
    margin: const EdgeInsets.all(8),
    flushbarPosition: FlushbarPosition.TOP,
    positionOffset: 20.0,
  ).show(context); // Menggunakan context yang diteruskan
}

// Menampilkan Flushbar error
void showErrorFlushbar(BuildContext context, String message) {
  Flushbar(
    title: 'Gagal',
    message: message,
    icon: const Icon(
      Icons.error,
      color: Colors.white,
    ),
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.red.shade600,
    borderRadius: BorderRadius.circular(8),
    margin: const EdgeInsets.all(8),
    flushbarPosition: FlushbarPosition.TOP,
    positionOffset: 20.0,
  ).show(context); // Menggunakan context yang diteruskan
}
