class AbsensiEntity {
  final int idPegawai; // Tambahkan ini
  final DateTime tanggal;
  final String statusAbsen;
  final DateTime? waktuMasuk;
  final DateTime? waktuKeluar;
  final String lokasiAbsen;

  AbsensiEntity({
    required this.idPegawai, // Tambahkan ini
    required this.tanggal,
    required this.statusAbsen,
    this.waktuMasuk,
    this.waktuKeluar,
    required this.lokasiAbsen,
  });

  factory AbsensiEntity.fromJson(Map<String, dynamic> json) {
    if (json['idPegawai'] == null) {
      throw Exception('idPegawai is required');
    }

    return AbsensiEntity(
      idPegawai: json['idPegawai'] is int
          ? json['idPegawai']
          : int.tryParse(json['idPegawai'].toString()) ?? 0,
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
