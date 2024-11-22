import 'package:presensia/domain/entities/attendance_entity.dart';
import '../../domain/entities/pegawai.dart';

abstract class AttendanceRepository {
  Future<List<AttendanceEntity>> getTodaysAttendance(int idPegawai);
  Future<PegawaiEntity> getUser(int idPegawai);
}
