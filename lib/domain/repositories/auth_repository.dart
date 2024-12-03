import '../entities/pegawai.dart';
import 'dart:io';

abstract class AuthRepository {
  Future<PegawaiEntity> register({
    required String noPegawai,
    required String alamat,
    required String noHp,
    required String password,
  });

  Future<Map<String, dynamic>> registerImage({
    required int idPegawai,
    required List<File> files,
  });

  Future<PegawaiEntity> login({
    required String noPegawai,
    required String password,
  });

  Future<void> logout();
}
