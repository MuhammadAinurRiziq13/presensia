import 'package:equatable/equatable.dart';
import 'package:presensia/data/models/absensi_model.dart';

class AbsensiEntity extends Equatable {
  final int idPegawai;
  final DateTime tanggal;
  final String statusAbsen;
  final DateTime? waktuMasuk;
  final DateTime? waktuKeluar;
  final String lokasiAbsen;

  const AbsensiEntity({
    required this.idPegawai,
    required this.tanggal,
    required this.statusAbsen,
    this.waktuMasuk,
    this.waktuKeluar,
    required this.lokasiAbsen,
  });

  factory AbsensiEntity.fromModel(AbsensiModel model) {
    return AbsensiEntity(
      idPegawai: model.idPegawai,
      tanggal: model.tanggal,
      statusAbsen: model.statusAbsen,
      waktuMasuk: model.waktuMasuk,
      waktuKeluar: model.waktuKeluar,
      lokasiAbsen: model.lokasiAbsen,
    );
  }

  factory AbsensiEntity.fromJson(Map<String, dynamic> json) {
    return AbsensiEntity(
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

  Map<String, dynamic> toJson() {
    return {
      'id_pegawai': idPegawai,
      'tanggal': tanggal.toIso8601String(),
      'status_absen': statusAbsen,
      'waktu_masuk': waktuMasuk?.toIso8601String(),
      'waktu_keluar': waktuKeluar?.toIso8601String(),
      'lokasi_absen': lokasiAbsen,
    };
  }

  @override
  List<Object?> get props => [
        idPegawai,
        tanggal,
        statusAbsen,
        waktuMasuk,
        waktuKeluar,
        lokasiAbsen,
      ];
}
