import '../../data/models/attendance_model.dart';
import '../../data/models/pegawai_model.dart'; // Import PegawaiModel
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
}
