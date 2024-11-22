import 'package:presensia/domain/entities/attendance_entity.dart';

class AttendanceModel extends AttendanceEntity {
  const AttendanceModel({
    required int idAbsen,
    required int idPegawai,
    required String statusAbsen,
    required String lokasiAbsen,
    String? fotoAbsen,
    required DateTime tanggal,
    DateTime? waktuMasuk,
    DateTime? waktuKeluar,
  }) : super(
          idAbsen: idAbsen,
          idPegawai: idPegawai,
          statusAbsen: statusAbsen,
          lokasiAbsen: lokasiAbsen,
          fotoAbsen: fotoAbsen,
          tanggal: tanggal,
          waktuMasuk: waktuMasuk,
          waktuKeluar: waktuKeluar,
        );

  // Convert model from JSON to object
  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      idAbsen: json['id_absen'],
      idPegawai: json['id_pegawai'],
      statusAbsen: json['status_absen'],
      lokasiAbsen: json['lokasi_absen'],
      fotoAbsen: json['foto_absen'],
      tanggal: DateTime.parse(json['tanggal']),
      waktuMasuk: json['waktu_masuk'] != null
          ? DateTime.parse(json['waktu_masuk'])
          : null,
      waktuKeluar: json['waktu_keluar'] != null
          ? DateTime.parse(json['waktu_keluar'])
          : null,
    );
  }
}
