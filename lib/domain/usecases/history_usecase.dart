import 'package:presensia/domain/entities/absensi.dart';
import 'package:presensia/domain/repositories/history_repository.dart';

class GetHistoryUseCase {
  final HistoryRepository _historyRepository;

  // Menerima HistoryRepository melalui konstruktor
  GetHistoryUseCase(this._historyRepository);

  Future<List<AbsensiEntity>> execute(int idPegawai) async {
    if (idPegawai <= 0) {
      throw Exception('Invalid ID Pegawai: $idPegawai'); // Validasi ID Pegawai
    }

    try {
      // Memanggil method getHistory dari repository untuk mendapatkan data absensi
      final absensiList = await _historyRepository.getHistory(idPegawai);
      return absensiList;
    } catch (e) {
      // Menangani jika terjadi error
      print("Error in GetHistoryUseCase: $e"); // Logging error
      throw Exception('Error loading history: ${e.toString()}');
    }
  }
}
