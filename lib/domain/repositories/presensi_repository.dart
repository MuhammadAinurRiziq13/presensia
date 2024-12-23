import 'dart:io';
import 'package:presensia/domain/entities/attendance_entity.dart';

abstract class PresensiRepository {
  Future<AttendanceEntity> storePresensi({
    required int idPegawai,
    required File fotoAbsen,
    required String lokasiAbsen,
  });
}
