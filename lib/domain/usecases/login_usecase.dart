import '../entities/pegawai.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<PegawaiEntity> execute({
    required String noPegawai,
    required String password,
  }) async {
    return await _authRepository.login(
      noPegawai: noPegawai,
      password: password,
    );
  }
}
