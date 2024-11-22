import 'package:presensia/data/datasources/history_api_datasource.dart';
import 'package:presensia/domain/entities/absensi.dart';
import 'package:presensia/domain/repositories/history_repository.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryApiDataSource _historyApiDataSource;

  HistoryRepositoryImpl(this._historyApiDataSource);

  @override
  Future<List<AbsensiEntity>> getHistory(int idPegawai) async {
    try {
      // Pastikan id_pegawai adalah integer
      if (idPegawai is! int) {
        throw Exception('id_pegawai harus berupa integer');
      }

      return await _historyApiDataSource.getHistory({"id_pegawai": idPegawai});
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}
