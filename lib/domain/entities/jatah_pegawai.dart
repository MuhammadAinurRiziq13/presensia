import 'package:equatable/equatable.dart';

class JatahPegawaiEntity extends Equatable {
  final int idJatah;
  final int idPegawai;
  final int jatahSakit;
  final int jatahCuti;
  final int sisaSakit;
  final int sisaCuti;
  final int tahun;

  const JatahPegawaiEntity({
    required this.idJatah,
    required this.idPegawai,
    required this.jatahSakit,
    required this.jatahCuti,
    required this.sisaSakit,
    required this.sisaCuti,
    required this.tahun,
  });

  @override
  List<Object?> get props => [
        idJatah,
        idPegawai,
        jatahSakit,
        jatahCuti,
        sisaSakit,
        sisaCuti,
        tahun,
      ];
}
