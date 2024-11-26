import '../repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _authRepository;

  LogoutUseCase(this._authRepository);

  Future<void> execute() async {
    try {
      await _authRepository.logout();
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }
}
