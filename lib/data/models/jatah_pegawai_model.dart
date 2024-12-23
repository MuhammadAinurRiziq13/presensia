import '../../domain/entities/jatah_pegawai.dart';

class JatahPegawaiModel extends JatahPegawaiEntity {
  const JatahPegawaiModel({
    required int idJatah,
    required int idPegawai,
    required int jatahSakit,
    required int jatahCuti,
    required int sisaSakit,
    required int sisaCuti,
    required int tahun,
  }) : super(
          idJatah: idJatah,
          idPegawai: idPegawai,
          jatahSakit: jatahSakit,
          jatahCuti: jatahCuti,
          sisaSakit: sisaSakit,
          sisaCuti: sisaCuti,
          tahun: tahun,
        );

  // Convert JSON to Model
  factory JatahPegawaiModel.fromJson(Map<String, dynamic> json) {
    return JatahPegawaiModel(
      idJatah: json['id_jatah'] ?? 0, // Jika null, gunakan default 0
      idPegawai: json['id_pegawai'] ?? 0,
      jatahSakit: json['jatah_sakit'] ?? 0,
      jatahCuti: json['jatah_cuti'] ?? 0,
      sisaSakit: json['sisa_sakit'] ?? 0,
      sisaCuti: json['sisa_cuti'] ?? 0,
      tahun: json['tahun'] ?? 0,
    );
  }

  // Convert Model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id_jatah': idJatah,
      'id_pegawai': idPegawai,
      'jatah_sakit': jatahSakit,
      'jatah_cuti': jatahCuti,
      'sisa_sakit': sisaSakit,
      'sisa_cuti': sisaCuti,
      'tahun': tahun,
    };
  }
}
