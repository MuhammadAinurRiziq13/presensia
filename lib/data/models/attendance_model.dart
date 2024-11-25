import 'package:presensia/domain/entities/attendance_entity.dart';

class AttendanceModel extends AttendanceEntity {
  const AttendanceModel({
    required int idAbsen,
    required int idPegawai,
    required String statusAbsen,
    required String lokasiAbsen,
    String? fotoAbsen,
    DateTime? tanggal, // Nullable
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
      idAbsen: int.tryParse(json['id_absensi'].toString()) ?? 0,
      idPegawai: int.tryParse(json['id_pegawai'].toString()) ?? 0,
      statusAbsen: json['status_absen'] ?? 'Unknown',
      lokasiAbsen: json['lokasi_absen'] ?? 'Unknown',
      fotoAbsen: json['foto_absen'], // Nullable
      tanggal:
          json['tanggal'] != null ? DateTime.tryParse(json['tanggal']) : null,
      waktuMasuk: json['waktu_masuk'] != null
          ? DateTime.tryParse(json['waktu_masuk'])
          : null,
      waktuKeluar: json['waktu_keluar'] != null
          ? DateTime.tryParse(json['waktu_keluar'])
          : null,
    );
  }
}
