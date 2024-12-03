import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class PermitEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetPermitsEvent extends PermitEvent {
  final int idPegawai;

  GetPermitsEvent({required this.idPegawai});

  @override
  List<Object?> get props => [idPegawai];
}

class SubmitPermitEvent extends PermitEvent {
  final int idPegawai;
  final String jenisIzin;
  final String keterangan;
  final DateTime tanggalMulai;
  final DateTime tanggalAkhir;
  final File? dokumen; // Mengubah menjadi File? bukan String?

  SubmitPermitEvent({
    required this.idPegawai,
    required this.jenisIzin,
    required this.keterangan,
    required this.tanggalMulai,
    required this.tanggalAkhir,
    this.dokumen, // Dokumen opsional, bisa null
  });

  @override
  List<Object?> get props => [
        idPegawai,
        jenisIzin,
        keterangan,
        tanggalMulai,
        tanggalAkhir,
        dokumen ?? '', // Dokumen bisa null
      ];
}
