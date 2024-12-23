import 'dart:io';

abstract class PresensiEvent {}

class SubmitPresensiEvent extends PresensiEvent {
  final File fotoAbsen;
  final double? latitude;
  final double? longitude;
  final String lokasiAbsen;

  SubmitPresensiEvent({
    required this.fotoAbsen,
    this.latitude,
    this.longitude,
    required this.lokasiAbsen,
  });
}
