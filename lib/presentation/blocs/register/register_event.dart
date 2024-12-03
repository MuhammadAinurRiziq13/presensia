import 'dart:io';

abstract class RegisterEvent {}

class RegisterButtonPressed extends RegisterEvent {
  final String noPegawai;
  final String alamat;
  final String noHp;
  final String password;

  RegisterButtonPressed({
    required this.noPegawai,
    required this.alamat,
    required this.noHp,
    required this.password,
  })  : assert(noPegawai.isNotEmpty, 'Nomor Pegawai tidak boleh kosong'),
        assert(alamat.isNotEmpty, 'Alamat tidak boleh kosong'),
        assert(noHp.isNotEmpty, 'Nomor HP tidak boleh kosong'),
        assert(password.isNotEmpty, 'Password tidak boleh kosong');
}

class RegisterImageEvent extends RegisterEvent {
  final int idPegawai;
  final List<File> files;

  RegisterImageEvent({required this.idPegawai, required this.files});

  @override
  List<Object?> get props => [idPegawai, files];
}
