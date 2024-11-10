abstract class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final String noPegawai;
  final String password;

  LoginButtonPressed({
    required this.noPegawai,
    required this.password,
  });
}
