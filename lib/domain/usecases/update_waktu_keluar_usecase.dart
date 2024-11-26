import 'package:presensia/domain/entities/attendance_entity.dart';
import 'package:presensia/domain/repositories/home_repository.dart';

class UpdateWaktuKeluarUseCase {
  final AttendanceRepository _repository;

  UpdateWaktuKeluarUseCase(this._repository);

  Future<AttendanceEntity> execute(int idAbsensi) async {
    return await _repository.updateWaktuKeluar(idAbsensi: idAbsensi);
  }
}
