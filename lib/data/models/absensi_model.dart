import 'package:presensia/domain/entities/absensi.dart';

class AbsensiEntity {
  final DateTime tanggal;
  final String statusAbsen;
  final DateTime? waktuMasuk;
  final DateTime? waktuKeluar;
  final String lokasiAbsen;

  AbsensiEntity({
    required this.tanggal,
    required this.statusAbsen,
    this.waktuMasuk,
    this.waktuKeluar,
    required this.lokasiAbsen,
  });

  factory AbsensiEntity.fromJson(Map<String, dynamic> json) {
    return AbsensiEntity(
      tanggal: DateTime.parse(json['tanggal']),
      statusAbsen: json['statusAbsen'],
      waktuMasuk: json['waktuMasuk'] != null
          ? DateTime.parse(json['waktuMasuk'])
          : null,
      waktuKeluar: json['waktuKeluar'] != null
          ? DateTime.parse(json['waktuKeluar'])
          : null,
      lokasiAbsen: json['lokasiAbsen'],
    );
  }
}
