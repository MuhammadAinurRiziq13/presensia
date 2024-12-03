import 'dart:io';
import 'package:presensia/domain/repositories/auth_repository.dart';

class RegisterImageUseCase {
  final AuthRepository _authRepository;

  RegisterImageUseCase(this._authRepository);

  Future<Map<String, dynamic>> execute({
    required int idPegawai,
    required List<File> files,
  }) async {
    try {
      return await _authRepository.registerImage(
        idPegawai: idPegawai,
        files: files,
      );
    } catch (e) {
      throw Exception('Register Image UseCase Error: ${e.toString()}');
    }
  }
}
