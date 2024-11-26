import 'dart:io';

abstract class PresensiEvent {}

class SubmitPresensiEvent extends PresensiEvent {
  final File fotoAbsen;

  SubmitPresensiEvent({
    required this.fotoAbsen,
  });
}
