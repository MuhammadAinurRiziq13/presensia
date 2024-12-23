import '../datasources/auth_api_datasource.dart';
import '../../domain/entities/pegawai.dart';
import '../../domain/repositories/auth_repository.dart';
import 'dart:io';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiDataSource _authApiDataSource;

  AuthRepositoryImpl(this._authApiDataSource);

  @override
  Future<PegawaiEntity> register({
    required String noPegawai,
    required String alamat,
    required String noHp,
    required String password,
  }) async {
    try {
      final pegawaiModel = await _authApiDataSource.register(
        noPegawai: noPegawai,
        alamat: alamat,
        noHp: noHp,
        password: password,
      );
      print('Registration success: ${pegawaiModel.namaPegawai}');
      return pegawaiModel;
    } catch (e) {
      print('Registration failed: ${e.toString()}');
      rethrow;
    }
  }

  // Register Image
  @override
  Future<Map<String, dynamic>> registerImage({
    required int idPegawai,
    required List<File> files,
  }) async {
    try {
      final response = await _authApiDataSource.registerImage(
        idPegawai: idPegawai,
        files: files,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PegawaiEntity> login({
    required String noPegawai,
    required String password,
  }) async {
    try {
      final pegawaiModel = await _authApiDataSource.login(
        noPegawai: noPegawai,
        password: password,
      );
      print('Login success: ${pegawaiModel.namaPegawai}');
      return pegawaiModel;
    } catch (e) {
      print('Login failed: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _authApiDataSource.logout();
      print('Logout success');
    } catch (e) {
      print('Logout failed: ${e.toString()}');
      rethrow;
    }
  }
}
