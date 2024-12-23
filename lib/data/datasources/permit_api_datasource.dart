import 'dart:io';
import 'package:dio/dio.dart';
import '../../data/models/permit_model.dart';
import '../../core/utils/dio_client/dio_client.dart';

class PermitApiDataSource {
  final DioClient _dioClient;

  PermitApiDataSource(this._dioClient);

  Future<List<PermitModel>> getPermits(int idPegawai) async {
    try {
      final response = await _dioClient.get(
        '/permit/history',
        queryParams: {'id_pegawai': idPegawai},
      );

      if (response.statusCode == 200) {
        print('Response JSON: ${response.data}');

        List? data = response.data['data'];
        if (data == null || data.isEmpty) {
          return [];
        }

        return data.map((item) => PermitModel.fromJson(item)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to fetch permits');
      }
    } catch (e) {
      throw Exception('Error loading permits: ${e.toString()}');
    }
  }

  Future<PermitModel> submitPermit({
    required int idPegawai,
    required String jenisIzin,
    required String keterangan,
    required DateTime tanggalMulai,
    required DateTime tanggalAkhir,
    File? dokumen, // Dokumen opsional
  }) async {
    if (idPegawai <= 0) {
      throw Exception("Id Pegawai tidak valid");
    }
    final formData = FormData.fromMap({
      'id_pegawai': idPegawai.toString(),
      'jenis_izin': jenisIzin,
      'keterangan': keterangan,
      'tanggal_mulai': tanggalMulai.toIso8601String(),
      'tanggal_akhir': tanggalAkhir.toIso8601String(),
      if (dokumen != null) // Hanya kirim dokumen jika ada
        'dokumen': await MultipartFile.fromFile(
          dokumen.path,
          filename: dokumen.path.split('/').last,
        ),
    });

    final response = await _dioClient.post(
      '/permit/store',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    if (response.statusCode == 200) {
      return PermitModel.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? 'Failed to submit permit');
    }
  }
}
