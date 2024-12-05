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
  final String jenisIzin;
  final String keterangan;
  final DateTime tanggalMulai;
  final DateTime tanggalAkhir;
  final File? dokumen; // Dokumen opsional, bisa null

  SubmitPermitEvent({
    required this.jenisIzin,
    required this.keterangan,
    required this.tanggalMulai,
    required this.tanggalAkhir,
    this.dokumen,
    // required int idPegawai, // Dokumen opsional, bisa null
  });

  // @override
  // List<Object?> get props => [
  //       jenisIzin,
  //       keterangan,
  //       tanggalMulai,
  //       tanggalAkhir,
  //       dokumen ?? '', // Dokumen bisa null
  //     ];
}
