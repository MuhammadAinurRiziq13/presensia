import 'package:presensia/domain/entities/absensi.dart';

abstract class HistoryRepository {
  Future<List<AbsensiEntity>> getHistory(int idPegawai);
}
