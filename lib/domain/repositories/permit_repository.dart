import 'dart:io';
import 'package:presensia/domain/entities/permit.dart';

abstract class PermitRepository {
  /// Mendapatkan daftar izin berdasarkan ID pegawai
  Future<List<PermitEntity>> getPermits(int idPegawai);

  /// Mengirimkan permintaan izin baru
  Future<PermitEntity> submitPermit({
    required int idPegawai,
    required String jenisIzin,
    required String keterangan,
    required DateTime tanggalMulai,
    required DateTime tanggalAkhir,
    File? dokumen, // Dokumen bersifat opsional
  });
}
