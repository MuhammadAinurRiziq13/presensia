import 'package:presensia/domain/repositories/home_repository.dart';
import '../entities/attendance_entity.dart';

class GetTodaysAttendanceUseCase {
  final AttendanceRepository _repository;

  GetTodaysAttendanceUseCase(this._repository);

  Future<List<AttendanceEntity>> execute(int idPegawai) async {
    return await _repository.getTodaysAttendance(idPegawai);
  }
}
