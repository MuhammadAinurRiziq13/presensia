import '../entities/pegawai.dart';

abstract class AuthRepository {
  Future<PegawaiEntity> register({
    required String noPegawai,
    required String alamat,
    required String noHp,
    required String password,
  });

  Future<PegawaiEntity> login({
    required String noPegawai,
    required String password,
  });

  Future<void> logout();
}
