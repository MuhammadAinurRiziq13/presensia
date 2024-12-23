import 'dart:io';
import 'package:presensia/domain/entities/permit.dart';
import 'package:presensia/domain/repositories/permit_repository.dart';

class PermitUseCase {
  final PermitRepository _permitRepository;

  PermitUseCase(this._permitRepository);

  Future<List<PermitEntity>> execute(int idPegawai) async {
    return await _permitRepository.getPermits(idPegawai);
  }

  Future<PermitEntity> submitPermit({
    required int idPegawai,
    required String jenisIzin,
    required String keterangan,
    required DateTime tanggalMulai,
    required DateTime tanggalAkhir,
    File? dokumen,
  }) async {
    return await _permitRepository.submitPermit(
      idPegawai: idPegawai,
      jenisIzin: jenisIzin,
      keterangan: keterangan,
      tanggalMulai: tanggalMulai,
      tanggalAkhir: tanggalAkhir,
      dokumen: dokumen,
    );
  }
}
