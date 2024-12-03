import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/pegawai_model.dart';
import '../../core/utils/dio_client/dio_client.dart';
import 'dart:io';
import 'package:dio/dio.dart';

class AuthApiDataSource {
  final DioClient _dioClient;

  AuthApiDataSource(this._dioClient);

  /// Register
  Future<PegawaiModel> register({
    required String noPegawai,
    required String alamat,
    required String noHp,
    required String password,
  }) async {
    final response = await _dioClient.post(
      '/register',
      data: {
        'no_pegawai': noPegawai,
        'alamat': alamat,
        'nohp': noHp,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      // Pastikan backend mengembalikan data pegawai yang valid
      return PegawaiModel.fromJson(response.data['pegawai']);
    } else {
      throw Exception(response.data['message'] ?? 'Register failed');
    }
  }

  // Register Image
  Future<Map<String, dynamic>> registerImage({
    required int idPegawai,
    required List<File> files,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'id_pegawai': idPegawai,
        'files[]': await Future.wait(files.map((file) async {
          return await MultipartFile.fromFile(file.path,
              filename: file.uri.pathSegments.last);
        })),
      });

      final response = await _dioClient.post(
        '/registerImage',
        data: formData, // Mengirimkan FormData
      );

      if (response.statusCode == 422) {
        // Tangani kesalahan 422 di sini, misalnya menampilkan pesan kesalahan yang lebih jelas
        print("Data tidak valid: ${response.data['message']}");
      }

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to upload images');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  /// Login (dengan menyimpan token)
  Future<PegawaiModel> login({
    required String noPegawai,
    required String password,
  }) async {
    final response = await _dioClient.post(
      '/login',
      data: {
        'no_pegawai': noPegawai,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final token = response.data['authorization']['token'];

      // Validasi token
      if (token is! String || token.isEmpty) {
        throw Exception('Invalid token received from server');
      }

      // Simpan token ke SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);

      // Kembalikan data pegawai
      return PegawaiModel.fromJson(response.data['pegawai']);
    } else {
      throw Exception(response.data['message'] ?? 'Login failed');
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Hapus semua data di SharedPreferences
      await prefs.clear();
    } catch (e) {
      throw Exception('Failed to logout: ${e.toString()}');
    }
  }
}
  // /// Logout (hapus token dari SharedPreferences)
  // Future<void> logout() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove('auth_token');
  // }

  // /// Check jika pengguna sudah login
  // Future<bool> isLoggedIn() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('auth_token');
  //   return token != null && token.isNotEmpty;
  // }