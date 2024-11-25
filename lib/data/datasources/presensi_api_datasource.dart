import 'dart:io';
import 'package:dio/dio.dart';
import 'package:presensia/core/utils/dio_client/dio_client.dart';
import 'package:presensia/data/models/attendance_model.dart';

class PresensiApiDataSource {
  final DioClient _dioClient;

  PresensiApiDataSource(this._dioClient);

  Future<AttendanceModel> storePresensi({
    required int idPegawai,
    required File fotoAbsen,
  }) async {
    if (idPegawai <= 0) {
      throw Exception("Id Pegawai tidak valid");
    }

    try {
      final formData = FormData.fromMap({
        'id_pegawai': idPegawai
            .toString(), // Kirim sebagai string jika backend mengharapkan string
        'foto_absen': await MultipartFile.fromFile(
          fotoAbsen.path,
          filename: fotoAbsen.path.split('/').last,
        ),
      });

      final response = await _dioClient.client.post(
        '/presensi/store',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      // Print hasil respons untuk debugging
      print("===================================================");
      print("API Response: ${response.data}");

      if (response.statusCode == 200) {
        return AttendanceModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to store presensi');
      }
    } catch (e) {
      throw Exception('Error storing presensi: ${e.toString()}');
    }
  }
}
