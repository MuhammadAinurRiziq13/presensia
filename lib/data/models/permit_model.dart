class Permit {
  final int id;
  final String jenisIzin;
  final String tanggalMulai;
  final String tanggalSelesai;
  final String keterangan;
  final String status;

  Permit({
    required this.id,
    required this.jenisIzin,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.keterangan,
    required this.status,
  });

  factory Permit.fromJson(Map<String, dynamic> json) {
    return Permit(
      id: json['id'],
      jenisIzin: json['jenis_izin'],
      tanggalMulai: json['tanggal_mulai'],
      tanggalSelesai: json['tanggal_selesai'],
      keterangan: json['keterangan'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jenis_izin': jenisIzin,
      'tanggal_mulai': tanggalMulai,
      'tanggal_selesai': tanggalSelesai,
      'keterangan': keterangan,
    };
  }
}
