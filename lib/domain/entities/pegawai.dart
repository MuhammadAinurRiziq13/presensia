import 'package:equatable/equatable.dart';

class PegawaiEntity extends Equatable {
  final int? id;
  final int? idLevel;
  final String? namaPegawai;
  final String noPegawai;
  final int? boss;
  final String? jabatan;
  final String alamat;
  final String noHp;
  final String password;
  final String? token; // Menambahkan token JWT

  const PegawaiEntity({
    this.id,
    this.idLevel,
    this.namaPegawai,
    required this.noPegawai, // Tetap required
    this.boss,
    this.jabatan,
    required this.alamat,
    required this.noHp,
    required this.password,
    this.token,
  });

  @override
  List<Object?> get props => [
        id,
        idLevel,
        namaPegawai,
        noPegawai,
        boss,
        jabatan,
        alamat,
        noHp,
        password,
        token,
      ];
}
