import 'dart:io';
import 'package:presensia/data/datasources/presensi_api_datasource.dart';
import 'package:presensia/domain/entities/attendance_entity.dart';
import 'package:presensia/domain/repositories/presensi_repository.dart';

class PresensiRepositoryImpl implements PresensiRepository {
  final PresensiApiDataSource _apiDataSource;

  PresensiRepositoryImpl(this._apiDataSource);

  @override
  Future<AttendanceEntity> storePresensi({
    required int idPegawai,
    required File fotoAbsen,
  }) async {
    final model = await _apiDataSource.storePresensi(
      idPegawai: idPegawai,
      fotoAbsen: fotoAbsen,
    );
    return AttendanceEntity.fromModel(model);
  }
}
