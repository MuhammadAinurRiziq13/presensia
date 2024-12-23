import '../entities/jatah_pegawai.dart';
import '../repositories/home_repository.dart';

class GetRemainingQuotaUseCase {
  final AttendanceRepository _repository;

  GetRemainingQuotaUseCase(this._repository);

  Future<JatahPegawaiEntity> execute(int idPegawai) async {
    return await _repository.getRemainingQuota(idPegawai);
  }
}
