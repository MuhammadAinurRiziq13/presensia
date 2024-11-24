import '../datasources/history_api_datasource.dart';
import '../../domain/entities/absensi.dart';
import '../../domain/repositories/history_repository.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryApiDataSource _historyApiDataSource;

  HistoryRepositoryImpl(this._historyApiDataSource);

  @override
  Future<List<AbsensiEntity>> getHistory(int idPegawai) async {
    try {
      // Mendapatkan data dari data source yang berupa List<AbsensiModel>
      final absensiModels = await _historyApiDataSource.getHistory(idPegawai);

      // Mengkonversi List<AbsensiModel> ke List<AbsensiEntity>
      return absensiModels
          .map((model) => AbsensiEntity.fromModel(model))
          .toList();
    } catch (e) {
      print('Error fetching history: ${e.toString()}');
      rethrow;
    }
  }
}
