import 'dart:io';
import 'package:presensia/domain/entities/attendance_entity.dart';
import 'package:presensia/domain/repositories/presensi_repository.dart';

class StorePresensiUseCase {
  final PresensiRepository _repository;

  StorePresensiUseCase(this._repository);

  Future<AttendanceEntity> execute({
    required int idPegawai,
    required File fotoAbsen,
  }) async {
    return await _repository.storePresensi(
      idPegawai: idPegawai,
      fotoAbsen: fotoAbsen,
    );
  }
}
