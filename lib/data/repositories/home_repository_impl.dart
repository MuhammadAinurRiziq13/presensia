import '../datasources/home_api_datasource.dart';
import '../../domain/entities/attendance_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/entities/pegawai.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceApiDataSource _attendanceApiDataSource;

  AttendanceRepositoryImpl(this._attendanceApiDataSource);

  @override
  Future<List<AttendanceEntity>> getTodaysAttendance(int idPegawai) async {
    try {
      final attendanceModels =
          await _attendanceApiDataSource.getTodaysAttendance(idPegawai);
      return attendanceModels
          .map((model) => AttendanceEntity.fromModel(model))
          .toList();
    } catch (e) {
      print('Error fetching attendance: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<PegawaiEntity> getUser(int idPegawai) async {
    try {
      final pegawaiModel = await _attendanceApiDataSource.getUser(idPegawai);
      return PegawaiEntity(
        id: pegawaiModel.id,
        namaPegawai: pegawaiModel.namaPegawai,
        jabatan: pegawaiModel.jabatan,
        noPegawai: pegawaiModel.noPegawai,
        alamat: pegawaiModel.alamat,
        noHp: pegawaiModel.noHp,
        password: pegawaiModel.password,
      );
    } catch (e) {
      print('Error fetching user: ${e.toString()}');
      rethrow;
    }
  }
}
