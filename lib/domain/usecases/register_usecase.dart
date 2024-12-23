import 'package:presensia/domain/entities/pegawai.dart';
import 'package:presensia/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _authRepository;

  RegisterUseCase(this._authRepository);

  Future<PegawaiEntity> execute({
    required String noPegawai,
    required String alamat,
    required String noHp,
    required String password,
  }) async {
    return await _authRepository.register(
      noPegawai: noPegawai,
      alamat: alamat,
      noHp: noHp,
      password: password,
    );
  }
}
