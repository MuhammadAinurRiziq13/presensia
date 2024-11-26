import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:presensia/core/utils/dio_client/dio_client.dart'; // Pastikan DioClient sudah tersedia

class ProfileApiDataSource {
  final DioClient _dioClient;

  ProfileApiDataSource(this._dioClient);

  Future<bool> updatePassword(
      int idPegawai, String oldPassword, String newPassword) async {
    if (idPegawai <= 0) {
      throw Exception("Id Pegawai tidak valid");
    }

    try {
      final response = await _dioClient.client.post(
        '/password/update',
        data: jsonEncode({
          'id_pegawai': idPegawai,
          'password': oldPassword,
          'password_baru': newPassword,
        }),
        options: Options(
          contentType: 'application/json',
        ),
      );

      // Print response for debugging
      print("===================================================");
      print("API Response: ${response.data}");

      if (response.statusCode == 200) {
        // Password berhasil diubah
        return true;
      } else {
        throw Exception(
            response.data['message'] ?? 'Failed to update password');
      }
    } catch (e) {
      throw Exception('Error updating password: ${e.toString()}');
    }
  }
}
