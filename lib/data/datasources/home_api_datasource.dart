import '../../data/models/attendance_model.dart';
import '../../data/models/pegawai_model.dart';
import '../../core/utils/dio_client/dio_client.dart';

class AttendanceApiDataSource {
  final DioClient _dioClient;

  AttendanceApiDataSource(this._dioClient);

  Future<List<AttendanceModel>> getTodaysAttendance(int idPegawai) async {
    try {
      final response = await _dioClient.post(
        '/home/today',
        data: {'id_pegawai': idPegawai},
      );

      if (response.statusCode == 200) {
        print('Response JSON: ${response.data}');
        List? data = response.data['data'];
        if (data == null || data.isEmpty) {
          return [];
        }
        return data.map((item) => AttendanceModel.fromJson(item)).toList();
      } else {
        throw Exception(
            response.data['message'] ?? 'Failed to fetch attendance');
      }
    } catch (e) {
      throw Exception("Error fetching attendance: ${e.toString()}");
    }
  }

  Future<PegawaiModel> getUser(int idPegawai) async {
    try {
      final response = await _dioClient.post(
        '/home/user',
        data: {'id_pegawai': idPegawai},
      );

      if (response.statusCode == 200) {
        print('Response JSON: ${response.data}');
        return PegawaiModel.fromJson(response.data['data']);
      } else {
        throw Exception(
            response.data['message'] ?? 'Failed to fetch user data');
      }
    } catch (e) {
      throw Exception("Error fetching user: ${e.toString()}");
    }
  }

  Future<JatahPegawaiModel> getRemainingQuota(int idPegawai) async {
    try {
      final response = await _dioClient.post(
        '/home/quota',
        data: {'id_pegawai': idPegawai},
      );

      print('Quota API Response: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return JatahPegawaiModel.fromJson(data);
      } else {
        throw Exception(
            response.data['message'] ?? 'Failed to fetch quota data');
      }
    } catch (e) {
      throw Exception('Error fetching quota: ${e.toString()}');
    }
  }

  Future<AttendanceModel> updateWaktuKeluar(int idAbsensi) async {
    try {
      final response = await _dioClient.client.post(
        '/presensi/update',
        data: {'id_absensi': idAbsensi},
      );

      if (response.statusCode == 200) {
        return AttendanceModel.fromJson(response.data['data']);
      } else {
        throw Exception(
            response.data['message'] ?? 'Gagal memperbarui waktu keluar');
      }
    } catch (e) {
      throw Exception('Error updating waktu keluar: ${e.toString()}');
    }
  }
}
