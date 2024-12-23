import 'package:equatable/equatable.dart';
import 'package:presensia/data/models/permit_model.dart';

class PermitEntity extends Equatable {
  final int idIzin;
  final int idPegawai;
  final String jenisIzin;
  final String statusIzin;
  final DateTime tanggalMulai;
  final DateTime tanggalAkhir;
  final String? keterangan;
  final String? dokumen;

  const PermitEntity({
    required this.idIzin,
    required this.idPegawai,
    required this.jenisIzin,
    required this.statusIzin,
    required this.tanggalMulai,
    required this.tanggalAkhir,
    this.keterangan,
    this.dokumen,
  });

  factory PermitEntity.fromModel(PermitModel model) {
    return PermitEntity(
      idIzin: model.idIzin,
      idPegawai: model.idPegawai,
      jenisIzin: model.jenisIzin,
      statusIzin: model.statusIzin,
      tanggalMulai: model.tanggalMulai,
      tanggalAkhir: model.tanggalAkhir,
      keterangan: model.keterangan,
      dokumen: model.dokumen,
    );
  }

  factory PermitEntity.fromJson(Map<String, dynamic> json) {
    return PermitEntity(
      idIzin: json['id_izin'],
      idPegawai: json['id_pegawai'],
      jenisIzin: json['jenis_izin'],
      statusIzin: json['status_izin'],
      tanggalMulai: DateTime.parse(json['tanggal_mulai']),
      tanggalAkhir: DateTime.parse(json['tanggal_akhir']),
      keterangan: json['keterangan'],
      dokumen: json['dokumen']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_izin': idIzin,
      'id_pegawai': idPegawai,
      'jenis_izin': jenisIzin,
      'status_izin': statusIzin,
      'tanggal_mulai': tanggalMulai.toIso8601String(),
      'tanggal_akhir': tanggalAkhir.toIso8601String(),
      'keterangan': keterangan,
      'dokumen': dokumen,
    };
  }

  @override
  List<Object?> get props => [
        idIzin,
        idPegawai,
        jenisIzin,
        statusIzin,
        tanggalMulai,
        tanggalAkhir,
        keterangan,
        dokumen,
      ];
}
