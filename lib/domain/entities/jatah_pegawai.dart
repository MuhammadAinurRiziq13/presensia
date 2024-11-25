import 'package:equatable/equatable.dart';

class JatahPegawaiEntity extends Equatable {
  final int idJatah;
  final int idPegawai;
  final int jatahWfa;
  final int jatahCuti;
  final int sisaWfa;
  final int sisaCuti;
  final int tahun;

  const JatahPegawaiEntity({
    required this.idJatah,
    required this.idPegawai,
    required this.jatahWfa,
    required this.jatahCuti,
    required this.sisaWfa,
    required this.sisaCuti,
    required this.tahun,
  });

  @override
  List<Object?> get props => [
        idJatah,
        idPegawai,
        jatahWfa,
        jatahCuti,
        sisaWfa,
        sisaCuti,
        tahun,
      ];
}
