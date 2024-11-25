import '../../data/models/absensi_model.dart';
import '../../core/utils/dio_client/dio_client.dart';

class HistoryApiDataSource {
  final DioClient _dioClient;

  HistoryApiDataSource(this._dioClient);

  Future<List<AbsensiModel>> getHistory(int idPegawai) async {
    try {
      // Kirim permintaan ke API
      final response = await _dioClient.get(
        '/history',
        queryParams: {'id_pegawai': idPegawai},
      );

      // Cek status code respon
      if (response.statusCode == 200) {
        print('Response JSON: ${response.data}');

        // Ambil data absensi dari respon
        List? data = response.data['data'];
        if (data == null || data.isEmpty) {
          return [];
        }

        // Mapping JSON menjadi List<AbsensiModel>
        return data.map((item) => AbsensiModel.fromJson(item)).toList();
      } else {
        // Jika status code bukan 200, lempar exception dengan pesan dari server
        throw Exception(response.data['message'] ?? 'Failed to fetch history');
      }
    } catch (e) {
      // Tangani error dan log pesan error
      throw Exception('Error loading history: ${e.toString()}');
    }
  }
}
