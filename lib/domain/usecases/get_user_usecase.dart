import '../../domain/entities/pegawai.dart';
import '../../domain/repositories/home_repository.dart';

class GetUserUseCase {
  final AttendanceRepository _repository;

  GetUserUseCase(this._repository);

  Future<PegawaiEntity> execute(int idPegawai) async {
    return await _repository.getUser(idPegawai);
  }
}
