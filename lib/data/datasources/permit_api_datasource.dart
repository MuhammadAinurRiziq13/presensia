import 'dart:io';
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

  Future<PermitModel> submitPermit(Map<String, dynamic> payload,
      {required int idPegawai,
      required String jenisIzin,
      required String keterangan,
      required DateTime tanggalMulai,
      required DateTime tanggalAkhir,
      File? dokumen}) async {
    try {
      final response = await _dioClient.post(
        '/permit/store',
        data: payload,
      );

      if (response.statusCode == 201) {
        print('Response JSON: ${response.data}');
        return PermitModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to submit permit');
      }
    } catch (e) {
      throw Exception('Error submitting permit: ${e.toString()}');
    }
  }
}
