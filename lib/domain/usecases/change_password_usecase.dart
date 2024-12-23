import 'package:presensia/domain/repositories/profile_repository.dart';

class ChangePasswordUseCase {
  final ProfileRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<bool> execute(
      int idPegawai, String oldPassword, String newPassword) async {
    return await repository.changePassword(idPegawai, oldPassword, newPassword);
  }
}
