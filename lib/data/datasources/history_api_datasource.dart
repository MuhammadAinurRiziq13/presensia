import 'package:dio/dio.dart';
import 'package:presensia/domain/entities/absensi.dart';

class HistoryApiDataSource {
  final Dio _dio;

  HistoryApiDataSource(this._dio);

  Future<List<AbsensiEntity>> getHistory(
      Map<String, dynamic> queryParameters) async {
    try {
      final idPegawai = queryParameters['id_pegawai'];
      print('Mencoba mengambil history untuk ID Pegawai: $idPegawai');

      final response = await _dio
          .get('/history', queryParameters: {'id_pegawai': idPegawai});

      if (response.statusCode == 200) {
        final List data = response.data;
        print('Data berhasil diterima: ${data.length} item');
        return data.map((json) => AbsensiEntity.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load history');
      }
    } catch (e) {
      print('Error saat mengambil history: $e');
      throw Exception('Error loading history: $e');
    }
  }
}
