import 'package:presensia/domain/entities/attendance_entity.dart';
import 'package:presensia/domain/entities/jatah_pegawai.dart';
import '../../domain/entities/pegawai.dart';

abstract class AttendanceRepository {
  Future<List<AttendanceEntity>> getTodaysAttendance(int idPegawai);
  Future<PegawaiEntity> getUser(int idPegawai);
  Future<JatahPegawaiEntity> getRemainingQuota(int idPegawai);

  Future<AttendanceEntity> updateWaktuKeluar({
    required int idAbsensi,
  });
}
