import 'package:presensia/domain/entities/permit.dart';

class PermitModel extends PermitEntity {
  const PermitModel({
    required int idIzin,
    required int idPegawai,
    required String jenisIzin,
    required String statusIzin,
    required DateTime tanggalMulai,
    required DateTime tanggalAkhir,
    String? keterangan,
    String? dokumen,
  }) : super(
          idIzin: idIzin,
          idPegawai: idPegawai,
          jenisIzin: jenisIzin,
          statusIzin: statusIzin,
          tanggalMulai: tanggalMulai,
          tanggalAkhir: tanggalAkhir,
          keterangan: keterangan,
          dokumen: dokumen,
        );

  factory PermitModel.fromJson(Map<String, dynamic> json) {
    return PermitModel(
      idIzin: int.tryParse(json['id_izin'].toString()) ?? 0,
      idPegawai: int.tryParse(json['id_pegawai'].toString()) ?? 0,
      jenisIzin: json['jenis_izin'] ?? 'Unknown',
      statusIzin: json['status_izin'] ?? 'Unknown',
      tanggalMulai: DateTime.parse(json['tanggal_mulai']),
      tanggalAkhir: DateTime.parse(json['tanggal_akhir']),
      keterangan: json['keterangan'] ?? 'Unknown',
      dokumen: json['dokumen'], // Konversi ke string jika ada
    );
  }
}
