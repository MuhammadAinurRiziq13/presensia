import '../../domain/entities/pegawai.dart';

class PegawaiModel extends PegawaiEntity {
  const PegawaiModel({
    int? id,
    int? idLevel,
    String? namaPegawai,
    required String noPegawai,
    int? boss,
    String? jabatan,
    required String alamat,
    required String noHp,
    required String password,
  }) : super(
          id: id,
          idLevel: idLevel,
          namaPegawai: namaPegawai,
          noPegawai: noPegawai,
          boss: boss,
          jabatan: jabatan,
          alamat: alamat,
          noHp: noHp,
          password: password,
        );

  factory PegawaiModel.fromJson(Map<String, dynamic> json) {
    return PegawaiModel(
      id: json['id_pegawai'] as int?,
      idLevel: json['id_level'] as int?,
      namaPegawai: json['nama_pegawai'] ?? '',
      noPegawai: json['no_pegawai']?.toString() ?? '', // Konversi ke String
      boss: json['supervisor'] as int?,
      jabatan: json['jabatan'] ?? '',
      alamat: json['alamat'] ?? '',
      noHp: json['nohp'] ?? '',
      password: '', // Password tidak disimpan di aplikasi
    );
  }
}
