import 'package:presensia/domain/entities/absensi.dart';

class AbsensiModel extends AbsensiEntity {
  const AbsensiModel({
    required int idPegawai,
    required DateTime tanggal,
    required String statusAbsen,
    DateTime? waktuMasuk,
    DateTime? waktuKeluar,
    required String lokasiAbsen,
  }) : super(
          idPegawai: idPegawai,
          tanggal: tanggal,
          statusAbsen: statusAbsen,
          waktuMasuk: waktuMasuk,
          waktuKeluar: waktuKeluar,
          lokasiAbsen: lokasiAbsen,
        );

  // Convert model from JSON to object
  factory AbsensiModel.fromJson(Map<String, dynamic> json) {
    return AbsensiModel(
      idPegawai: json['id_pegawai'],
      tanggal: DateTime.parse(json['tanggal']),
      statusAbsen: json['status_absen'],
      waktuMasuk: json['waktu_masuk'] != null
          ? DateTime.parse(json['waktu_masuk'])
          : null,
      waktuKeluar: json['waktu_keluar'] != null
          ? DateTime.parse(json['waktu_keluar'])
          : null,
      lokasiAbsen: json['lokasi_absen'],
    );
  }
}
